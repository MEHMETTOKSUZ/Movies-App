//
//  CartViewModel.swift
//  MoviesScroll
//
//  Created by Mehmet ÖKSÜZ on 21.05.2023.
//

import Foundation

class CartViewModel {
    
    var received: [MoviesCell.ViewModel] = []
    var didFinishLoad: (() -> Void)?
    var didFinishLoadWithError: ((String) -> Void)?
    
    var numberOfReceived: Int {
        return received.count
    }
    
    func getReceived(at index: Int) -> MoviesCell.ViewModel {
        return received[index]
    }
    
    func loadRecivedData() {
        if let receivedData = UserDefaults.standard.object(forKey: "AddedCartMovies") as? Data {
            let receivedSaved = try? JSONDecoder().decode([Results].self, from: receivedData)
            presentCart(results: receivedSaved ?? [])
            self.didFinishLoad?()
        } else {
            self.didFinishLoadWithError?("Error")
        }
        
        func presentCart(results: [Results]) {
            let viewModel: [MoviesCell.ViewModel] = results.map { result in
                convertResults(result: result)
            }
            self.received = viewModel
            self.didFinishLoad?()
        }
    }
    func convertResults(result: Results) -> MoviesCell.ViewModel {
        let string =  "https://image.tmdb.org/t/p/w500" + result.poster_path
        let url = URL(string: string)
        let imdbRating = String(format: "%.1f / 10 IMDb", result.vote_average)
        
        let model = MoviesCell.ViewModel(
            id: result.id,
            overview: result.overview,
            name: result.original_title,
            image: url,
            imdb: imdbRating,
            data: result
        )
        return model
    }
    
}
