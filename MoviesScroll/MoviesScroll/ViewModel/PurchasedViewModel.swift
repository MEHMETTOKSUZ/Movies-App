//
//  PurchasedViewModel.swift
//  MoviesScroll
//
//  Created by Mehmet ÖKSÜZ on 19.05.2023.
//

import Foundation

class PurchasedViewModel {
    
    var purchsedData: [MoviesCell.ViewModel] = []
    var rentData: [MoviesCell.ViewModel] = []
    var didFinishLoad: (() -> Void)?
    var didFinishLoadWithError: ((String) -> Void)?
    
    var numberOfPurshased: Int {
        return purchsedData.count
    }
    
    var numberOfRent: Int {
        return rentData.count
    }
    
    func getPurchased(at index: Int) -> MoviesCell.ViewModel {
        return purchsedData[index]
        
    }
    func getRent(at index: Int) -> MoviesCell.ViewModel {
        return rentData[index]
    }
    
    func deletePurchased(item: Results) {
        if let index = purchsedData.firstIndex(where: {$0.id == item.id}) {
            purchsedData.remove(at: index)
        }
    }
    
    func loadPurchaseData() {
        if let purchasedData = UserDefaults.standard.object(forKey: "PurchasedMovies") as? Data {
            let purchasedSaved = try? JSONDecoder().decode([Results].self, from: purchasedData)
            self.presentPurchased(results: purchasedSaved ?? [])
            self.didFinishLoad?()
        } else {
        }
    }
    func loadRentData() {
        if let rentedData = UserDefaults.standard.object(forKey: "RentMovies") as? Data {
            let rentSaved = try? JSONDecoder().decode([Results].self, from: rentedData)
            self.presentRent(results: rentSaved ?? [])
            self.didFinishLoad?()
        } else {
        }
    }
    func presentPurchased(results: [Results]) {
        let viewModel: [MoviesCell.ViewModel] = results.map { result in
            convertResult(results: result)
        }
        self.purchsedData = viewModel
        self.didFinishLoad?()
    }
    func presentRent(results: [Results]) {
        let viewModel: [MoviesCell.ViewModel] = results.map { result in
            convertResult(results: result)
        }
        self.rentData = viewModel
        self.didFinishLoad?()
    }
    
    func convertResult(results: Results) -> MoviesCell.ViewModel {
        let string = "https://image.tmdb.org/t/p/w500" + results.poster_path
        let url = URL(string: string)
        let imdbRating = String(format: "%.1f / 10 IMDb", results.vote_average)
        let model = MoviesCell.ViewModel(
            id: results.id,
            overview: results.overview,
            name: results.original_title,
            image: url,
            imdb: imdbRating,
            data: results
        )
        
        return model
        
    }
}
