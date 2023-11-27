//
//  FavoriteViewModel.swift
//  MoviesScroll
//
//  Created by Mehmet ÖKSÜZ on 18.05.2023.
//

import Foundation

class FavoriteViewModel {
    
    var favoriteMovies: [MoviesCell.ViewModel] = []
    var favoriteTVShows: [TvShowsCell.ViewModel] = []
    var didFinishLoad: (() -> Void)?
    var didFinishLoadWithError: ((String) -> Void)?
    
    var numberOfMovies: Int {
        return favoriteMovies.count
    }
    
    var numberOfTVShows: Int {
        return favoriteTVShows.count
    }
    
    func getFavoriteMovies(at index: Int) -> MoviesCell.ViewModel {
        return favoriteMovies[index]
    }
    
    func getFavoriteTVShows(at index: Int) -> TvShowsCell.ViewModel {
        return favoriteTVShows[index]
    }
    
    func loadFavoriteMovies() {
        if let favorites = UserDefaults.standard.object(forKey: "favoriteMovies") as? Data {
            let savedItems = try? JSONDecoder().decode([Results].self, from: favorites)
            self.presentFavoriteMovies(result: savedItems ?? [])
            self.didFinishLoad?()
        } else {
            self.didFinishLoadWithError?("Error")
        }
    }
    
    func loadFavoriteTVShows() {
        if let favorites = UserDefaults.standard.object(forKey: "favoriteTVShows") as? Data {
            let savedItems = try? JSONDecoder().decode([TVResults].self, from: favorites)
            self.presentFavoriteTVShow(result: savedItems ?? [])
            self.didFinishLoad?()
        } else {
            self.didFinishLoadWithError?("Error")
        }
    }
    
    func presentFavoriteMovies(result: [Results]) {
        let viewModel: [MoviesCell.ViewModel] = result.map { result in
            convertResults(result: result)
        }
        self.favoriteMovies = viewModel
        self.didFinishLoad?()
    }
    
    func presentFavoriteTVShow(result: [TVResults]) {
        let viewModel: [TvShowsCell.ViewModel] = result.map { result in
            convertTVResults(result: result)
        }
        self.favoriteTVShows = viewModel
        self.didFinishLoad?()
    }
    
    func convertResults(result: Results) -> MoviesCell.ViewModel {
        let string = "https://image.tmdb.org/t/p/w500" + (result.poster_path)
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
    
    func convertTVResults(result: TVResults) -> TvShowsCell.ViewModel {
        let string = "https://image.tmdb.org/t/p/w500" + (result.poster_path)
        let url = URL(string: string)
        let imdbRating = String(format: "%.1f / 10 IMDb", result.vote_average)
        let model = TvShowsCell.ViewModel(
            id: result.id,
            name: result.originalName,
            image: url,
            imdb: imdbRating,
            overview: result.overview,
            data: result
        )
        return model
        
    }
}

