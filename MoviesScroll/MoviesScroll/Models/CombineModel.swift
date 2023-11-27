//
//  CombinedModel.swift
//  MoviesScroll
//
//  Created by Mehmet ÖKSÜZ on 24.02.2023.
//

import Foundation

struct Movies: Codable {
    
    var results: [Results]
}

struct Results: Codable, Equatable {
    let id: Int
    let original_title: String
    let overview: String
    let poster_path: String
    let release_date: String
    let vote_average: Double
    let genre_ids: [Int]
}

struct MovieGenres: Codable {
    let genres: [Genre]
}

struct Genre: Codable {
    let id: Int
    let name: String
}

struct MovieDetail: Codable {
    let id: Int
    let homepage: String?
    let runtime: Int?
}


struct TVShows: Codable {
    
    var results : [TVResults]
    
}
struct TVResults: Codable {
    
    
    let id: Int
    let original_title: String?
    let originalName: String
    let overview: String
    let poster_path: String
    let vote_average: Double
    let first_air_date: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case original_title
        case originalName = "original_name"
        case overview
        case poster_path = "poster_path"
        case vote_average
        case first_air_date
    }
}

struct Credits: Codable {
    
    var cast: [Cast]
}

struct Cast: Codable , Equatable {
    let id: Int
    let name: String
    let character: String
    let profile_path: String?
    init(id: Int, name: String, character: String, profile_path: String?) {
        self.id = id
        self.name = name
        self.character = character
        self.profile_path = profile_path
    }
}

struct MovieCastingCredits: Codable {
    let id: Int
    let crew: [Crew]
}

struct Crew: Codable {
    let department, job, name: String
    
    enum CodingKeys: String, CodingKey {
        case department, job, name
    }
}

struct MovieVideoDetails: Codable {
    let id: Int
    let title: String
    let overview: String
    let releaseDate: String
    let posterPath: String?
    let videos: MovieVideoResults?
}

struct MovieVideoResults: Codable {
    let results: [MovieVideo]
}

struct MovieVideo: Codable {
    let id: String
    let key: String
    let name: String
    let site: String
    let type: String
}

struct TVShowVideoDetails: Codable {
    let id: Int
    let name: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let firstAirDate: String?
    let voteAverage: Double?
    let videos: TvShowVideoResults?
    
}

struct TvShowVideoResults: Codable {
    let results: [TvShowVideo]
}

struct TvShowVideo: Codable {
    let key: String
    let name: String
    let type: String
    let site: String
}


struct ReviewsResponse: Codable {
    
    let results: [Review]
}

struct Review: Codable {
    let id: String
    let author: String
    let content: String
    let url: String
    let avatar_path: URL?
    let updated_at: String
    let rating: Double?
    
    
}
 



















