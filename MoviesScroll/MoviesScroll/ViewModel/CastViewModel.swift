//
//  DetailsViewModel.swift
//  MoviesScroll
//
//  Created by Mehmet ÖKSÜZ on 25.05.2023.
//

import Foundation

class CastViewModel {
    
    var cast: [MoviesCastCell.ViewModel] = []
    var castTvShow: [TVShowsCastCell.TvShowCastViewModel] = []
    var didFinishLoad: (() -> Void)?
    var didFinishLoadWithError: ((String) -> Void)?
    
    var selectedMovieId: String
    
    init(selectedMovieId: String) {
        self.selectedMovieId = selectedMovieId
    }
    
    var numberOfTvShowCast: Int {
        return castTvShow.count
    }
    
    var numberOfCast: Int {
        return cast.count
    }
    
    func castTvShow(at index: Int) -> TVShowsCastCell.TvShowCastViewModel {
        return castTvShow[index]
    }
    
    func cast(at index: Int) -> MoviesCastCell.ViewModel {
        return cast[index]
    }
    
    func getCastTvShow() {
        
        guard let castActors = URL(string: "https://api.themoviedb.org/3/tv/\(Int(selectedMovieId)!)/credits?api_key=\(LocaleKey.API_KEY)") else {
            print("Invalid URL")
            return
        }
        WebService.shared.fetchMediaData(from: castActors) { (result: Result<Credits, Error>) in
            switch result {
            case .success(let actor):
                self.presentResultTvShow(result: actor.cast)
                self.didFinishLoad?()
            case .failure(let error):
                self.didFinishLoadWithError?(error.localizedDescription)
            }
        }
    }
    
    func getCast() {
        guard let castActors = URL(string: "https://api.themoviedb.org/3/movie/\(Int(selectedMovieId)!)/credits?api_key=\(LocaleKey.API_KEY)") else {
            print("Invalid URL")
            return
        }
        
        WebService.shared.fetchMediaData(from: castActors) { (result: Result<Credits, Error>) in
            switch result {
            case .success(let actor):
                self.presentCast(result: actor.cast)
                self.didFinishLoad?()
            case .failure(let error):
                self.didFinishLoadWithError?(error.localizedDescription)
            }
        }
    }
    
    func presentCast(result: [Cast]) {
        let viewModel: [MoviesCastCell.ViewModel] = result.map { results in
            convertResult(result: results)
        }
        self.cast = viewModel
        self.didFinishLoad?()
    }
    func presentResultTvShow(result: [Cast]) {
        let viewModel: [TVShowsCastCell.TvShowCastViewModel] = result.map { results in
            convertResultTvShow(result: results)
        }
        self.castTvShow = viewModel
        self.didFinishLoad?()
    }
    
    func convertResult(result: Cast) -> MoviesCastCell.ViewModel {
        let string = "https://image.tmdb.org/t/p/w500" + (result.profile_path ?? "")
        let url = URL(string: string)
        
        let model = MoviesCastCell.ViewModel(
            id: result.id,
            image: url,
            name: result.name,
            data: result
        )
        return model
    }
    
    func convertResultTvShow(result: Cast) -> TVShowsCastCell.TvShowCastViewModel {
        let string = "https://image.tmdb.org/t/p/w500" + (result.profile_path ?? "")
        let url = URL(string: string)
        
        let model = TVShowsCastCell.TvShowCastViewModel(
            id: result.id,
            image: url,
            name: result.name,
            data: result
        )
        return model
    }
}


