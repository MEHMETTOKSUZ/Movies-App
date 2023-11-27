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
        
        WebService().fetchCreditsData(from: creditsUrl) { result in
            switch result {
            case .success(let crew):
                let directors = crew.filter { $0.job == "Director" }
                let writers = crew.filter { $0.job == "Screenplay" }
                let producers = crew.filter { $0.job == "Producer" }
                
                let directorsText = "Directors: \n" + directors.map { $0.name }.joined(separator: "\n")
                let writersText = "Writers: \n" + writers.map { $0.name }.joined(separator: "\n")
                let producersText = "Producers: \n" + producers.map { $0.name }.joined(separator: "\n")
                
                let crewsViewModel = MoviesTableViewDetails.CrewsViewModel(
                    directors: directorsText,
                    writers: writersText,
                    productor: producersText
                )
                self.crews = crewsViewModel
                self.didFinishLoad?()
                
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
        WebService().fetchCreditsData(from: castingUrl) { result in
            switch result {
            case .success(let crew):
                let directors = crew.filter { $0.job == "Director" }
                let writers = crew.filter { $0.job == "Screenplay" }
                let producers = crew.filter { $0.job == "Producer" }
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

