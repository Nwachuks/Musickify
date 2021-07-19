//
//  AuthManager.swift
//  Musickify
//
//  Created by Nwachukwu Ejiofor on 18/07/2021.
//

import Foundation

final class AuthManager {
    static let instance = AuthManager()
    
    struct Constants {
        static let clientID = "bf6f4b88a21b4044955fe7011aa4e27b"
        static let clientSecret = "6bd76173181243ed921c6284f87d6688"
    }
    
    private init() {}
    
    public var signInURL: URL? {
        let baseURL = "https://accounts.spotify.com/authorize"
        let scopes = "user-read-private"
        let redirectURI = "https://www.iosacademy.io"
        let fullURL = "\(baseURL)?response_type=code&client_id=\(Constants.clientID)&scope=\(scopes)&redirect_uri=\(redirectURI)&show_dialog=TRUE"
        return URL(string: fullURL)
    }
    
    var isSignedIn: Bool {
        return false
    }
    
    private var accessToken: String? {
        return nil
    }
    
    private var refreshToken: String? {
        return nil
    }
    
    private var tokenExpirationDate: String? {
        return nil
    }
    
    private var shouldRefreshToken: Bool {
        return false
    }
    
    public func exchangeCodeForToken(string: String, completion: @escaping (Bool) -> Void) {
        // Get Token
    }
    
    private func cacheToken() {
        
    }
    
    public func refreshAccessToken() {
        
    }
}
