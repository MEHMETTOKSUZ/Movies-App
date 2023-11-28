//
//  GenresMoviesViewModel.swift
//  MoviesScroll
//
//  Created by Mehmet ÖKSÜZ on 21.05.2023.
//

import Foundation

import Foundation

class GenresMoviesViewModel {
    private let genre: String
    private let baseGenresUrl = "https://api.themoviedb.org/3/discover/movie?api_key=\(LocaleKey.API_KEY)&with_genres="
    private var movies: [MoviesCell.ViewModel] = []
    var didFinishLoad: (() -> Void)?
    var didFinishLoadWithError: ((String) -> Void)?
    var numberOfMovies: Int {
        return movies.count
    }
    
    init(genre: String?) {
        guard let selectedGenre = genre else {
            fatalError("No selected genre")
        }
        self.genre = selectedGenre
    }
    
    func fetchMovies() {
        let urlString: String
        switch genre {
        case "Aksiyon":
            urlString = "\(baseGenresUrl)28"
        case "Korku":
            urlString = "\(baseGenresUrl)27"
        case "Dram":
            urlString = "\(baseGenresUrl)18"
        case "Komedi":
            urlString = "\(baseGenresUrl)35"
        case "Savaş":
            urlString = "\(baseGenresUrl)10752"
        case "Macera":
            urlString = "\(baseGenresUrl)12"
        case "Animasyon":
            urlString = "\(baseGenresUrl)16"
        case "Fantastik":
            urlString = "\(baseGenresUrl)14"
        case "Romantik":
            urlString = "\(baseGenresUrl)10749"
        case "Bilim Kurgu":
            urlString = "\(baseGenresUrl)878"
        case "Aile":
            urlString = "\(baseGenresUrl)10751"
        case "Gizem":
            urlString = "\(baseGenresUrl)9648"
        default:
            fatalError("No selected genre")
        }
        
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL: \(urlString)")
        }
        
        WebService.shared.fetchMediaData(from: url) { [weak self] (result: Result<Movies, Error>) in
            switch result {
            case .success(let movies):
                self?.presentGenres(results: movies.results)
                self?.didFinishLoad?()
            case .failure(let error):
                self?.didFinishLoadWithError?(error.localizedDescription)
            }
        }
    }
    
    func getMovie(at index: Int) -> MoviesCell.ViewModel {
        return movies[index]
    }
    
    func presentGenres(results: [Results]) {
        let viewModel: [MoviesCell.ViewModel] = results.map { result in
            convertResults(result: result)
        }
        self.movies = viewModel
        self.didFinishLoad?()
    }
    
    func convertResults(result: Results) -> MoviesCell.ViewModel {
        let string = "https://image.tmdb.org/t/p/w500" + result.poster_path
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
}

