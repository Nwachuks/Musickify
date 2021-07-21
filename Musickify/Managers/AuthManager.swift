//
//  AuthManager.swift
//  Musickify
//
//  Created by Nwachukwu Ejiofor on 18/07/2021.
//

import Foundation

final class AuthManager {
    static let instance = AuthManager()
    
    private var refreshingToken = false
    private var onRefreshBlocks = [((String) -> Void)]()
    
    struct Constants {
        static let clientID = "bf6f4b88a21b4044955fe7011aa4e27b"
        static let clientSecret = "6bd76173181243ed921c6284f87d6688"
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        static let redirectURI = "https://www.iosacademy.io"
        static let scopes = [
            "user-read-private",
            "playlist-modify-public",
            "playlist-read-private",
            "playlist-modify-private",
            "user-follow-read",
            "user-library-modify",
            "user-library-read",
            "user-read-email"
        ]
        
        static let accessToken = "accessToken"
        static let refreshToken = "refreshToken"
        static let expirationDate = "expirationDate"
    }
    
    private init() {}
    
    public var signInURL: URL? {
        let baseURL = "https://accounts.spotify.com/authorize"
        let fullURL = "\(baseURL)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes.joined(separator: "%20"))&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
        return URL(string: fullURL)
    }
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: Constants.accessToken)
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: Constants.refreshToken)
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: Constants.expirationDate) as? Date
    }
    
    private var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else { return false }
        // Return true if expiration will expire in 5 minutes
        let currentDate = Date()
        let interval: TimeInterval = 300
        return currentDate.addingTimeInterval(interval) >= expirationDate
    }
    
    public func exchangeCodeForToken(code: String, completion: @escaping (Bool) -> Void) {
        // Get Token
        guard let url = URL(string: Constants.tokenAPIURL) else { return }
        
        // Create HTTP body
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI)
        ]
        
        // Create Base64 encoded string for authorization header
        let basicToken = Constants.clientID + ":" + Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Failure to get base 64 string")
            completion(false)
            return
        }
        
        // Build request url
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, _, error) in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            do {
//                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                print("SUCCESS: \(json)")
                
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result: result)
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
    }
    
    private func cacheToken(result: AuthResponse) {
        UserDefaults.standard.setValue(result.accessToken, forKey: Constants.accessToken)
        if let refreshToken = result.refreshToken {
            UserDefaults.standard.setValue(refreshToken, forKey: Constants.refreshToken)
        }
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expiresIn)), forKey: Constants.expirationDate)
    }
    
    // Get valid token to be used with network calls
    public func getValidToken(completion: @escaping (String) -> Void) {
        guard !refreshingToken else {
            // Append completion blocks if refresh already in progress
            onRefreshBlocks.append(completion)
            return
        }
        
        if shouldRefreshToken {
            refreshAccessToken { [weak self] success in
                if let token = self?.accessToken, success {
                    completion(token)
                }
            }
        } else if let token = accessToken {
            completion(token)
        }
    }
    
    public func refreshAccessToken(completion: @escaping (Bool) -> Void) {
        // Check refreshing token is not in progress already
        guard !refreshingToken else { return }
        
        guard shouldRefreshToken else {
            completion(true)
            return
        }
        
        guard let refreshToken = self.refreshToken else { return }
        
        // Refresh Token
        guard let url = URL(string: Constants.tokenAPIURL) else { return }
        
        refreshingToken = true
        
        // Create HTTP body
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken)
        ]
        
        // Create Base64 encoded string for authorization header
        let basicToken = Constants.clientID + ":" + Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Failure to get base 64 string")
            completion(false)
            return
        }
        
        // Build request url
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, _, error) in
            self?.refreshingToken = false
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                // Complete refresh token completions blocks if any
                self?.onRefreshBlocks.forEach { $0(result.accessToken) }
                self?.onRefreshBlocks.removeAll()
                self?.cacheToken(result: result)
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
    }
}
