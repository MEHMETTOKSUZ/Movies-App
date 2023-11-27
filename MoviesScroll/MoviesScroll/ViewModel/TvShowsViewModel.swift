//
//  TvShowsViewModel.swift
//  MoviesScroll
//
//  Created by Mehmet ÖKSÜZ on 17.05.2023.
//

import Foundation

class TVShowsViewModel {
    
    var tvTopRated: [TvShowsCell.ViewModel] = []
    var tvPopuler: [TvShowsCell.ViewModel] = []
    var didFinishLoad: (() -> Void)?
    var didFinishLoadWithError: ((String) -> Void)?
    
    var numberOfToprated: Int {
        return tvTopRated.count
    }
    
    var numberOfPopular: Int {
        return tvPopuler.count
    }
    
    func getTopRated(at index: Int) -> TvShowsCell.ViewModel {
        return tvTopRated[index]
    }
    
    func getPopular(at index: Int) -> TvShowsCell.ViewModel {
        return tvPopuler[index]
    }
    
    
    func fetchTvTopRated() {
        
        guard let urlTopRatedTVShow = URL(string: "https://api.themoviedb.org/3/tv/top_rated?api_key=\(LocaleKey.API_KEY)&language=en-US&page=1") else {
            print("Invalid URL")
            return
        }
        WebService().fetchMediaData(from: urlTopRatedTVShow) { (result: Result<TVShows, Error>) in
            switch result {
            case .success(let movies):
                self.presentTopRated(results: movies.results)
                self.didFinishLoad?()
            case .failure(let error):
                self.didFinishLoadWithError?(error.localizedDescription)
            }
        }
    }
    
    func fetchTVPopular() {
        
        guard let urlPopularTVShow = URL(string: "https://api.themoviedb.org/3/tv/popular?api_key=\(LocaleKey.API_KEY)&language=en-US&page=2") else {
            print("Invalid URL")
            return
        }
        WebService().fetchMediaData(from: urlPopularTVShow) { (result: Result<TVShows, Error>) in
            switch result {
            case .success(let movies):
                self.presentPopular(results: movies.results)
                self.didFinishLoad?()
            case .failure(let error):
                self.didFinishLoadWithError?(error.localizedDescription)
            }
        }
    }
    
    func presentTopRated(results: [TVResults]) {
        let viewModel: [TvShowsCell.ViewModel] = results.map { result in
            convertResult(result: result)
        }
        self.tvTopRated = viewModel
        self.didFinishLoad?()
    }
    
    func presentPopular(results: [TVResults]) {
        let viewModel: [TvShowsCell.ViewModel] = results.map { result in
            convertResult(result: result)
        }
        self.tvPopuler = viewModel
        self.didFinishLoad?()
    }
    
    
    func convertResult(result: TVResults) -> TvShowsCell.ViewModel {
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
