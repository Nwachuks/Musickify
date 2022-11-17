//
//  NetworkManager.swift
//  Musickify
//
//  Created by Nwachukwu Ejiofor on 18/07/2021.
//

import Foundation

final class NetworkManager {
    static let instance = NetworkManager()
    
    private init() {}
    
    struct Constants {
        static let baseAPIURL = "https://api.spotify.com/v1"
    }
    
    enum HTTPMethod: String {
        case GET
        case POST
    }
    
    enum APIError: Error {
        case failedToGetData
    }
    
    // Create base request with valid token and authorization
    private func createRequest(url: URL?, type: HTTPMethod, completion: @escaping (URLRequest) -> Void) {
        AuthManager.instance.getValidToken { token in
            guard let apiURL = url else { return }
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
    }
    
    // MARK: Profile
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        createRequest(url: URL(string: Constants.baseAPIURL + "/me"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    completion(.success(result))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
    
    // MARK: Albums
    public func getNewReleases(completion: @escaping (Result<NewReleases, Error>) -> Void) {
        createRequest(url: URL(string: Constants.baseAPIURL + "/browse/new-releases?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(NewReleases.self, from: data)
                    completion(.success(result))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getAlbumDetails(using albumId: String, completion: @escaping (Result<AlbumDetails, Error>) -> Void) {
        createRequest(url: URL(string: Constants.baseAPIURL + "/albums/\(albumId)"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(AlbumDetails.self, from: data)
                    completion(.success(result))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
     
    // MARK: Playlists
    public func getFeaturedPlaylists(completion: @escaping (Result<FeaturedPlaylists, Error>) -> Void) {
        createRequest(url: URL(string: Constants.baseAPIURL + "/browse/featured-playlists?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(FeaturedPlaylists.self, from: data)
                    completion(.success(result))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getPlaylistDetails(using playlistId: String, completion: @escaping (Result<PlaylistDetails, Error>) -> Void) {
        createRequest(url: URL(string: Constants.baseAPIURL + "/playlists/\(playlistId)"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(PlaylistDetails.self, from: data)
                    completion(.success(result))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: Categories
    public func getCategories(completion: @escaping (Result<[Category], Error>) -> Void) {
        createRequest(url: URL(string: Constants.baseAPIURL + "/browse/categories?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(AllCategories.self, from: data)
                    completion(.success(result.categories.items))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getCategoryPlaylists(using categoryId: String, completion: @escaping (Result<[Playlist], Error>) -> Void) {
        createRequest(url: URL(string: Constants.baseAPIURL + "/browse/categories/\(categoryId)/playlists?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(CategoryPlaylists.self, from: data)
                    let playlists = result.playlists.items
                    completion(.success(playlists))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: Recommendations
    public func getRecommendations(genres: Set<String>, completion: @escaping (Result<Recommendations, Error>) -> Void) {
        let seeds = genres.joined(separator: ",")
        createRequest(url: URL(string: Constants.baseAPIURL + "/recommendations?seed_genres=\(seeds)&limit=30"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }

                do {
                    let result = try JSONDecoder().decode(Recommendations.self, from: data)
                    completion(.success(result))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getRecommendedGenres(completion: @escaping (Result<RecommendedGenres, Error>) -> Void) {
        createRequest(url: URL(string: Constants.baseAPIURL + "/recommendations/available-genre-seeds/"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(RecommendedGenres.self, from: data)
                    completion(.success(result))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: Search
    public func search(with query: String, completion: @escaping (Result<[SearchResult], Error>) -> Void) {
        createRequest(url: URL(string: Constants.baseAPIURL + "/search?limit=10&type=album,artist,track,playlist&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(SearchResults.self, from: data)
                    
                    var searchResults: [SearchResult] = []
                    searchResults.append(contentsOf: result.albums.items.compactMap({ SearchResult.album(result: $0) }))
                    searchResults.append(contentsOf: result.artists.items.compactMap({ .artist(result: $0) }))
                    searchResults.append(contentsOf: result.tracks.items.compactMap({ .track(result: $0) }))
                    searchResults.append(contentsOf: result.playlists.items.compactMap({ .playlist(result: $0) }))
                    
                    completion(.success(searchResults))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
}
