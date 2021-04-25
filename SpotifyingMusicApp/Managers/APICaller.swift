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
    
//    public func getNewReleases(completion: @escaping ((Result<NewReleasesResponse, Error>)) -> Void) {
//        createRequest(
//            with: URL(string: Constants.baseAPIURL + "/browse/new-releases?limit=50"),
//            type: .GET
//        ) { request in
//            let task = URLSession.shared.dataTask(with: request) { ( data, _, error) in
//                guard let data = data, error == nil else {
//                    completion(.failure(APIError.failedToGetData))
//                    return
//                }
//
//                do {
//                    let result = try JSONDecoder().decode(NewReleasesResponse.self, from: data)
//                    completion(.success(result))
//                } catch {
//                    completion(.failure(error))
//                }
//            }
//            task.resume()
//        }
//    }
    
    public func getFeaturedPlaylists(completion: @escaping ((Result<FeaturedPlaylistsResponse, Error>)) -> Void) {
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
                    let result = try JSONDecoder().decode(FeaturedPlaylistsResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
//    public func getRecommendations(genres: Set<String>, completion: @escaping ((Result<RecommedationsResponse, Error>)) -> Void) {
//        let seeds = genres.joined(separator: ",")
//        createRequest(
//            with: URL(string: Constants.baseAPIURL + "/recommendations?limit=40&seed_genres=\(seeds)"),
//            type: .GET
//        ) { (request) in
//            let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
//                guard let data = data, error == nil else {
//                    completion(.failure(APIError.failedToGetData))
//                    return
//                }
//                
//                do {
//                    let result = try JSONDecoder().decode(RecommedationsResponse.self, from: data)
//                    completion(.success(result))
//                } catch {
//                    completion(.failure(error))
//                }
//            }
//            task.resume()
//        }
//    }
    
    public func getRecommendedGenres(completion: @escaping ((Result<RecommendedGenresResponse, Error>)) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/recommendations/available-genre-seeds"),
            type: .GET
        ) { (request) in
            let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(RecommendedGenresResponse.self, from: data)
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
