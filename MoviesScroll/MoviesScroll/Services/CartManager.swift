//
//  BuyManager.swift
//  MoviesScroll
//
//  Created by Mehmet ÖKSÜZ on 1.04.2023.
//

import Foundation


class CartManager {
    
    static let shared = CartManager()
    private init() {}
    
    private var purchasedMovies: [Results] = []
    private let defaults = UserDefaults.standard
    private let purchasedMoviesKey = "AddedCartMovies"
    
    func loadPurchaseMovies() {
        if let data = defaults.data(forKey: purchasedMoviesKey),
           let favoriteMovies = try? JSONDecoder().decode([Results].self, from: data) {
            self.purchasedMovies = favoriteMovies
            NotificationCenter.default.post(name: NSNotification.Name("newDataAdded"), object: nil)
        }
    }
    
    func togglePurchaseMovie(_ movie: Results) {
        if !purchasedMovies.contains(where: { $0.id == movie.id }) {
            purchasedMovies.append(movie)
        }
        updatePurchaseMovies()
        NotificationCenter.default.post(name: NSNotification.Name("newDataAdded"), object: nil)
    }
    
    func deletePurchaseMovie(_ movie: Results) {
        if let index = purchasedMovies.firstIndex(where: { $0.id == movie.id }) {
            purchasedMovies.remove(at: index)
        } else {
            print("error")
        }
        updatePurchaseMovies()
        NotificationCenter.default.post(name: NSNotification.Name("newDataAdded"), object: nil)
    }
    
    func isMoviePurchase(_ movie: Results) -> Bool {
        return purchasedMovies.contains { $0.id == movie.id }
    }
    
    
    public func updatePurchaseMovies() {
        if let data = try? JSONEncoder().encode(purchasedMovies) {
            defaults.set(data, forKey: purchasedMoviesKey)
        }
    }
    
    func clearPurchaseMovies() {
        purchasedMovies = []
        updatePurchaseMovies()
        NotificationCenter.default.post(name: NSNotification.Name("newDataAdded"), object: nil)
    }
}
