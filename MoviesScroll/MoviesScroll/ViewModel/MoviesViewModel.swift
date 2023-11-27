//
//  MoviesViewModel.swift
//  MoviesScroll
//
//  Created by Mehmet ÖKSÜZ on 13.05.2023.
//

import Foundation

class MoviesViewModel {
    
    var movies: [MoviesCell.ViewModel] = []
    var upcomingMovies: [MoviesCell.ViewModel] = []
    var didFinishLoad: (() -> Void)?
    var didFinishLoadWithError: ((String) -> Void)?
    
    var numberOfMovies: Int {
        return movies.count
    }
    
    var numberOfUpcomingMovies: Int {
        return upcomingMovies.count
    }
    
    func movie(at index: Int) -> MoviesCell.ViewModel {
        return movies[index]
    }
    
    func getUpcomingMovie(at index: Int) -> MoviesCell.ViewModel {
        return upcomingMovies[index]
    }
    
    func fetchMediaData() {
        
        guard let urlNowPlayingMovies = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(LocaleKey.API_KEY)&language=en-US&page=1") else {
            print("Invalid URL")
            return
        }
        WebService().fetchMediaData(from: urlNowPlayingMovies) { (result: Result<Movies, Error>) in
            switch result {
                
            case .success(let movies):
                self.presentMediaData(results: movies.results)
            case .failure(let error):
                self.didFinishLoadWithError?(error.localizedDescription)
            }
        }
    }
    
    func presentMediaData(results: [Results]) {
        let viewModel: [MoviesCell.ViewModel] = results.map { result in
            convertResult(result: result)
        }
        
        self.movies = viewModel
        self.didFinishLoad?()
    }
    
    func presentUpcomingMovies(results: [Results]) {
        let viewModel: [MoviesCell.ViewModel] = results.map { result in
            convertResult(result: result)
        }
        
        self.upcomingMovies = viewModel
        self.didFinishLoad?()
    }
    
    
    func convertResult(result: Results) -> MoviesCell.ViewModel {
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
    
    func fetchUpcomingMovies() {
        
        guard let urlUpcomingMovies = URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=\(LocaleKey.API_KEY)&language=en-US&page=2") else {
            print("Invalid URL")
            return
        }
        WebService().fetchMediaData(from: urlUpcomingMovies) { (result: Result<Movies, Error>) in
            switch result {
                
            case .success(let upcomingMovies):
                self.presentUpcomingMovies(results: upcomingMovies.results)
                self.didFinishLoad?()
            case .failure(let error):
                self.didFinishLoadWithError?(error.localizedDescription)
            }
        }
    }
}
