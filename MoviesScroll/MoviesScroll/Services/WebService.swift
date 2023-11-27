//
//  WebServiceLast.swift
//  MoviesScroll
//
//  Created by Mehmet ÖKSÜZ on 23.02.2023.
//

import Foundation


class WebService {
    
    func fetchMediaData<T: Codable>(from url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(error!))
                return
            }
            
            do {
                let results = try JSONDecoder().decode(T.self, from: data)
                completion(.success(results))
            } catch let error {
                print("API Error: ", error.localizedDescription)
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchMovieDetails(for movieId: Int, url: URL, completion: @escaping (MovieVideoDetails?) -> Void) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching movie details for ID \(movieId): \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let movieDetails = try decoder.decode(MovieVideoDetails.self, from: data)
                completion(movieDetails)
            } catch {
                print("Error decoding movie details for ID \(movieId): \(error)")
                completion(nil)
            }
        }.resume()
    }
    
    func fetchTVShowsDetails(for movieId: Int, url: URL, completion: @escaping (TVShowVideoDetails?) -> Void) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching movie details for ID \(movieId): \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let movieDetails = try decoder.decode(TVShowVideoDetails.self, from: data)
                completion(movieDetails)
            } catch {
                print("Error decoding movie details for ID \(movieId): \(error)")
                completion(nil)
            }
        }.resume()
    }
    
    
    func fetchCreditsData(from url: URL, completion: @escaping (Result<[Crew], Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(error!))
                return
            }
            
            do {
                let credits = try JSONDecoder().decode(MovieCastingCredits.self, from: data)
                let filteredCrew = credits.crew.filter { crew in
                    return crew.job == "Director" || crew.job == "Screenplay" || crew.job == "Producer"
                }
                completion(.success(filteredCrew))
            } catch let error {
                print("API Error: ", error.localizedDescription)
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchReview(from url: URL, completion: @escaping (Result<[Review], Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(error!))
                return
            }
            
            do {
                let results = try JSONDecoder().decode([Review].self, from: data)
                completion(.success(results))
            } catch let error {
                print("API Error: ", error.localizedDescription)
                completion(.failure(error))
            }
        }.resume()
    }
}









