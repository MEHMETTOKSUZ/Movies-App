//
//  CrewViewModel.swift
//  MoviesScroll
//
//  Created by Mehmet ÖKSÜZ on 12.06.2023.
//

import Foundation

class CreditsViewModel {
    
    var didFinishLoad: (() -> Void)?
    var didFinishWithError: ((String) -> Void)?
    var crews: MoviesTableViewDetails.CrewsViewModel?
    var tvShowCrew: TVShowsDetails.TvShowCrewsViewModel?
    
    func fetchCredits(movieId: String) {
        
        guard let creditsUrl = URL(string: "https://api.themoviedb.org/3/movie/\(Int(movieId)!)/credits?api_key=\(LocaleKey.API_KEY)") else {
            print("Invalid URL")
            return
        }
        
        WebService.shared.fetchMediaData(from: creditsUrl) { (result: Result<MovieCastingCredits, Error>) in
            switch result {
            case .success(let castingCredits):
                let directors = castingCredits.crew.filter { $0.job == "Director" }
                let writers = castingCredits.crew.filter { $0.job == "Screenplay" }
                let producers = castingCredits.crew.filter { $0.job == "Producer" }
                
                DispatchQueue.main.async {
                    let directorsText = "Directors:\n" + directors.map { $0.name }.joined(separator: "\n")
                    let writersText = "Writers:\n" + writers.map { $0.name }.joined(separator: "\n")
                    let producersText = "Producers:\n" + producers.map { $0.name }.joined(separator: "\n")
                    
                    let crewsViewModel = MoviesTableViewDetails.CrewsViewModel(
                        directors: directorsText,
                        writers: writersText,
                        productor: producersText
                    )
                    self.crews = crewsViewModel
                    self.didFinishLoad?()
                }
            case .failure(let error):
                self.didFinishWithError?(error.localizedDescription)
            }
        }
    }
    
    func fetchTvCrew(movieId: String) {
        guard let castingUrl = URL(string: "https://api.themoviedb.org/3/tv/\(Int(movieId)!)/credits?api_key=\(LocaleKey.API_KEY)&language=en-US") else {
            print("Invalid URL")
            return
        }
        
        WebService.shared.fetchMediaData(from: castingUrl) { (result: Result<MovieCastingCredits, Error>) in
            switch result {
            case .success(let castingCredits):
                let directors = castingCredits.crew.filter { $0.job == "Director" }
                let writers = castingCredits.crew.filter { $0.job == "Screenplay" }
                let producers = castingCredits.crew.filter { $0.job == "Producer" }
                
                DispatchQueue.main.async {
                    let directorsText = "Directors:\n" + directors.map { $0.name }.joined(separator: "\n")
                    let writersText = "Writers:\n" + writers.map { $0.name }.joined(separator: "\n")
                    let producersText = "Producers:\n" + producers.map { $0.name }.joined(separator: "\n")
                    
                    let crewsViewModel = TVShowsDetails.TvShowCrewsViewModel(
                        directors: directorsText,
                        productors: producersText,
                        writers: writersText
                    )
                    self.tvShowCrew = crewsViewModel
                    self.didFinishLoad?()
                }
            case .failure(let error):
                self.didFinishWithError?(error.localizedDescription)
            }
        }
    }

    func configureCrews() -> MoviesTableViewDetails.CrewsViewModel? {
        return crews
    }
    
    func configureTvCrews() -> TVShowsDetails.TvShowCrewsViewModel? {
        return tvShowCrew
    }
}

