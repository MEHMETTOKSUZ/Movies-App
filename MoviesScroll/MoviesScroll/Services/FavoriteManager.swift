//
//  shareModel.swift
//  MoviesScroll
//
//  Created by Mehmet ÖKSÜZ on 25.01.2023.
//

import Foundation

class FavoriteManager {
    
    static let shared = FavoriteManager()
    private init() {}
    
    private var favoriteMovies: [Results] = []
    private var favoriteTVShows: [TVResults] = []
    
    private let defaults = UserDefaults.standard
    
    private let favoriteMoviesKey = "favoriteMovies"
    private let favoriteTVShowsKey = "favoriteTVShows"
    
    func loadFavoriteMovies() {
        if let data = defaults.data(forKey: favoriteMoviesKey),
           let favoriteMovies = try? JSONDecoder().decode([Results].self, from: data) {
            self.favoriteMovies = favoriteMovies
            NotificationCenter.default.post(name: NSNotification.Name("newMoviesAdded"), object: nil)
        }
    }
    
    func loadFavoriteTVShows() {
        if let data = defaults.data(forKey: favoriteTVShowsKey),
           let favoriteTVShows = try? JSONDecoder().decode([TVResults].self, from: data) {
            self.favoriteTVShows = favoriteTVShows
            NotificationCenter.default.post(name: NSNotification.Name("newTvShowAdded"), object: nil)
        }
    }
    
    func toggleFavoriteMovie(_ movie: Results) {
        if let index = favoriteMovies.firstIndex(where: { $0.id == movie.id }) {
            favoriteMovies.remove(at: index)
        } else {
            favoriteMovies.append(movie)
        }
        updateFavoriteMovies()
        NotificationCenter.default.post(name: NSNotification.Name("newMoviesAdded"), object: nil)
    }
    
    func toggleFavoriteTVShow(_ tvShow: TVResults) {
        if let index = favoriteTVShows.firstIndex(where: { $0.id == tvShow.id }) {
            favoriteTVShows.remove(at: index)
            
        } else {
            favoriteTVShows.append(tvShow)
        }
        updateFavoriteTVShows()
        NotificationCenter.default.post(name: NSNotification.Name("newTvShowAdded"), object: nil)
    }
    
    func isMovieFavorite(_ movie: Results) -> Bool {
        return favoriteMovies.contains { $0.id == movie.id }
    }
    
    func isTVShowFavorite(_ tvShow: TVResults) -> Bool {
        return favoriteTVShows.contains { $0.id == tvShow.id }
    }
    
    func updateFavoriteMovies() {
        if let data = try? JSONEncoder().encode(favoriteMovies) {
            defaults.set(data, forKey: favoriteMoviesKey)
        }
    }
    
    func updateFavoriteTVShows() {
        if let data = try? JSONEncoder().encode(favoriteTVShows) {
            defaults.set(data, forKey: favoriteTVShowsKey)
            
        }
    }
    
    
}







