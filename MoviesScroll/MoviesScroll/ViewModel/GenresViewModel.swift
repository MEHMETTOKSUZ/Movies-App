//
//  GenresViewModel.swift
//  MoviesScroll
//
//  Created by Mehmet ÖKSÜZ on 11.06.2023.
//

import Foundation

class GenresViewModel {
    
    var didFinishLoad: (() -> Void)?
    var didFinishhWithError: ((String) -> Void)?
    var genres: [MoviesTableViewDetails.GenreViewModel] = []
    var tvShowGenres: [TVShowsDetails.TvShowGneresViewModel] = []
    
    func fetchGenres(movieId: String) {
        
        guard let genreUrl = URL(string: "https://api.themoviedb.org/3/movie/\(Int(movieId)!)?api_key=\(LocaleKey.API_KEY)&language=en-US&append_to_response=genres")
        else {
            print("Invalid URL")
            return
        }
        
        WebService.shared.fetchMediaData(from: genreUrl) { (result: Result<MovieGenres, Error>) in
            switch result {
            case.success(let movieGenre) :
                self.presentResults(results: movieGenre.genres)
                self.didFinishLoad?()
            case.failure(let error) :
                self.didFinishhWithError?(error.localizedDescription)
            }
        }
    }
    
    
    func fetchTvShowGenre(tvShowId: String) {
        
        guard let urlMovieGenres = URL(string: "https://api.themoviedb.org/3/tv/\(Int(tvShowId)!)?api_key=\(LocaleKey.API_KEY)&language=en-US&append_to_response=genres") else {
            print("Invalid URL")
            return
        }
        
        WebService.shared.fetchMediaData(from: urlMovieGenres) { (result: Result<MovieGenres, Error>) in
            switch result {
            case .success(let movieGenre):
                self.presentTvResults(result: movieGenre.genres)
                self.didFinishLoad?()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func presentResults(results: [Genre]) {
        let viewModel: [MoviesTableViewDetails.GenreViewModel] = results.map { result in
            convertResult(result: result)
        }
        
        self.genres = viewModel
        self.didFinishLoad?()
    }
    
    func presentTvResults(result: [Genre]) {
        let viewModel: [TVShowsDetails.TvShowGneresViewModel] = result.map { result in
            convertTvResult(result: result)
        }
        self.tvShowGenres = viewModel
        self.didFinishLoad?()
    }
    
    func convertTvResult(result: Genre) -> TVShowsDetails.TvShowGneresViewModel {
        let model = TVShowsDetails.TvShowGneresViewModel(genres: result.name)
        return model
    }
    
    func convertResult(result: Genre) -> MoviesTableViewDetails.GenreViewModel {
        
        let model = MoviesTableViewDetails.GenreViewModel(genres: result.name)
        return model
    }
    
}
