//
//  VideosViewModel.swift
//  MoviesScroll
//
//  Created by Mehmet ÖKSÜZ on 12.06.2023.
//

import Foundation


class VideosViewModel {
    
    var videos: MoviesTableViewDetails.VideoViewModel?
    var tvVideo: TVShowsDetails.TvShowVideoViewModel?
    var didFininshLoad: (() -> Void)?
    var didFinshLoadWithError: ((String) -> Void)?
    
    func getVideos(videoId: String) {
        guard let urlVideo = URL(string: "https://api.themoviedb.org/3/movie/\(videoId)?api_key=\(LocaleKey.API_KEY)&append_to_response=videos") else {
            print("Invalid URL")
            return
        }
        
        WebService.shared.fetchMediaData(from: urlVideo) { (result: Result<MovieVideoDetails?, Error>) in
               switch result {
               case .success(let videoDetails):
                   if let results = videoDetails?.videos?.results {
                       let videoViewModel = MoviesTableViewDetails.VideoViewModel(key: results.first?.key ?? "")
                       self.videos = videoViewModel
                       self.didFininshLoad?()
                   } else {
                       self.didFinshLoadWithError?("Failed to load videos.")
                   }
               case .failure(let error):
                   print("Error: \(error.localizedDescription)")
                   self.didFinshLoadWithError?("Failed to load videos.")
               }
           }
    }
    
    func getTvVideos(videoId: String) {
        
        guard let urlVideo = URL(string: "https://api.themoviedb.org/3/tv/\(videoId)?api_key=\(LocaleKey.API_KEY)&append_to_response=videos") else {
            print("Invalid URL")
            return
        }
        
        WebService.shared.fetchMediaData(from: urlVideo) { (result: Result<TVShowVideoDetails?, Error> ) in
            switch result {
            case .success(let videoDetails):
                if let results = videoDetails?.videos?.results {
                    let videoViewModel = TVShowsDetails.TvShowVideoViewModel(key: results.first?.key ?? "" )
                    self.tvVideo = videoViewModel
                    self.didFininshLoad?()
                } else {
                    self.didFinshLoadWithError?("Failed to load videos.")
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                self.didFinshLoadWithError?("Failed to load videos.")
            }
        }
    }
    
    func configureVideos() -> MoviesTableViewDetails.VideoViewModel? {
        return videos
    }
    
    func configureTvVideos() -> TVShowsDetails.TvShowVideoViewModel? {
        return tvVideo
    }
}

