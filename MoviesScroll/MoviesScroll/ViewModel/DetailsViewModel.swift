//
//  DetailsViewModel.swift
//  MoviesScroll
//
//  Created by Mehmet ÖKSÜZ on 11.06.2023.
//

import Foundation

class MovieDetailsViewModel {
    var didFinishLoad: (() -> Void)?
    var didFinishLoadWithError: ((String) -> Void)?
    var details: [MoviesTableViewDetails.DetailViewModel] = []
    
    func fetchMovieDetails(movieId: String) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(Int(movieId)!)?api_key=\(LocaleKey.API_KEY)") else {
            print("Invalid URL")
            return
        }
        
        WebService().fetchMediaData(from: url) { (result: Result<MovieDetail, Error>) in
            switch result {
            case .success(let movieDetails):
                self.presentDetails(result: [movieDetails])
                
                self.didFinishLoad?()
            case .failure(let error):
                self.didFinishLoadWithError?(error.localizedDescription)
            }
        }
    }
    func presentDetails(result: [MovieDetail]) {
        let viewModel: [MoviesTableViewDetails.DetailViewModel] = result.compactMap { results in
            convertDetails(result: results)
        }
        self.details = viewModel
        self.didFinishLoad?()
        
    }
    
    func convertDetails(result: MovieDetail) -> MoviesTableViewDetails.DetailViewModel? {
        let model = MoviesTableViewDetails.DetailViewModel(
            runTime: result.runtime ?? Int(0.0),
            homePage: result.homepage ?? "")
        return model
    }
    
}

