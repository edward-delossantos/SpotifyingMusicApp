//
//  APICaller.swift
//  SpotifyingMusicApp
//
//  Created by Edward de los Santos on 4/22/21.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    private init() {}
    
    struct Constants {
        static let baseAPIURL = "https://api.spotify.com/v1"
    }
    
    enum APIError: Error {
        case failedToGetData
    }
    
    public func getCurrentUserProfile(completion: @escaping(Result<UserProfile, Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/me"),
            type: .GET
        ) { (baseRequest) in
            let task = URLSession.shared.dataTask(with: baseRequest) { (data, _, error) in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    completion(.success(result))
                }
                catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getCategories(completion: @escaping(Result<CategoriesResponse, Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/browse/categories?limit=20"),
            type: .GET
        ) { (baseRequest) in
            let task = URLSession.shared.dataTask(with: baseRequest) { (data, _, error) in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(CategoriesResponse.self, from: data)
                    completion(.success(result))
                }
                catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getTopArtists(completion: @escaping(Result<ArtistsResponse, Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/me/top/artists"),
            type: .GET
        ) { (baseRequest) in
            let task = URLSession.shared.dataTask(with: baseRequest) { (data, _, error) in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(ArtistsResponse.self, from: data)
                    completion(.success(result))
                }
                catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getCurrentPlaylists(completion: @escaping(Result<PlaylistItems, Error>) -> Void) {
        let id = UserDefaults.standard.string(forKey: "user_id")
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/users/\(id!)/playlists"),
            type: .GET
        ) { (baseRequest) in
            let task = URLSession.shared.dataTask(with: baseRequest) { (data, _, error) in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(PlaylistItems.self, from: data)
                    completion(.success(result))
                }
                catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getPlaylists(categoryId: String, completion: @escaping(Result<PlaylistsResponse, Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/browse/categories/\(categoryId)/playlists?limit=20"),
            type: .GET
        ) { (baseRequest) in
            let task = URLSession.shared.dataTask(with: baseRequest) { (data, _, error) in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(PlaylistsResponse.self, from: data)
                    completion(.success(result))
                }
                catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getPlaylistTracks(playlistId: String, completion: @escaping(Result<TracksResponse, Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/playlists/\(playlistId)/tracks"),
            type: .GET
        ) { (baseRequest) in
            let task = URLSession.shared.dataTask(with: baseRequest) { (data, _, error) in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(TracksResponse.self, from: data)
                    completion(.success(result))
                }
                catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getFeaturedPlaylists(completion: @escaping ((Result<PlaylistsResponse, Error>)) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/browse/featured-playlists?limit=20"),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(PlaylistsResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    //MARK: - Private
    
    enum HTTPMethod: String {
        case GET
        case POST
    }
    
    private func createRequest(
        with url: URL?,
        type: HTTPMethod,
        completion: @escaping (URLRequest) -> Void
    ) {
        AuthManager.shared.withValidToken { (token) in
            guard let apiURL = url else {
                return
            }
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)",
                             forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
    }
}
