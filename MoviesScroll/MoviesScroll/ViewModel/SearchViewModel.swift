//
//  SearchViewModel.swift
//  MoviesScroll
//
//  Created by Mehmet ÖKSÜZ on 24.05.2023.
//

import Foundation

class SearchViewModel {
    
    var searchResults = [Any]()
    let baseUrl = "https://api.themoviedb.org/3"
    var choosenMovieName = ""
    var choosenMovieOverview = ""
    var choosenMovieImage = ""
    var choosenMovieImdb = ""
    var chosenMovieId = ""
    var choosenReleaseDate = ""
    
    func search(query: String, completion: @escaping ([Any]) -> Void) {
        
        let searchMovieUrl = "\(baseUrl)/search/movie?api_key=\(LocaleKey.API_KEY)&query="
        let searchTvShowUrl = "\(baseUrl)/search/tv?api_key=\(LocaleKey.API_KEY)&query="
        
        let query = query.replacingOccurrences(of: " ", with: "+")
        var results = [Any]()
        
        if let url = URL(string: searchMovieUrl + query) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else {
                    completion(results)
                    return
                }
                
                if let movieResults = try? JSONDecoder().decode(Movies.self, from: data) {
                    results.append(contentsOf: movieResults.results)
                }
                
                if let url = URL(string: searchTvShowUrl + query) {
                    URLSession.shared.dataTask(with: url) { data, response, error in
                        guard let data = data else {
                            completion(results)
                            return
                        }
                        
                        if let tvShowResults = try? JSONDecoder().decode(TVShows.self, from: data) {
                            results.append(contentsOf: tvShowResults.results)
                        }
                        
                        completion(results)
                    }.resume()
                } else {
                    completion(results)
                }
            }.resume()
        } else {
            completion(results)
        }
    }
    
    func didSelectMovie(at index: Int) {
        if let selectedMovie = searchResults[index] as? Results {
            choosenMovieName = selectedMovie.original_title
            choosenMovieImdb = String(selectedMovie.vote_average)
            choosenMovieImage = selectedMovie.poster_path
            choosenReleaseDate = selectedMovie.release_date
            chosenMovieId = String(selectedMovie.id)
            choosenMovieOverview = selectedMovie.overview
            
        }
    }
    
    func didSelectTVShow(at index: Int) {
        if let selectedTVShow = searchResults[index] as? TVResults {
            choosenMovieName = selectedTVShow.originalName
            choosenMovieImdb = String(selectedTVShow.vote_average)
            choosenMovieImage = selectedTVShow.poster_path
            choosenReleaseDate = selectedTVShow.first_air_date
            chosenMovieId = String(selectedTVShow.id)
            choosenMovieOverview = selectedTVShow.overview
            
        }
    }
}
