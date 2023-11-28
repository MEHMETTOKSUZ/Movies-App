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
}








