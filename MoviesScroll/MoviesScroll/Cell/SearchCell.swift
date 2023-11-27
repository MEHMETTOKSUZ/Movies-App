//
//  SearchCell.swift
//  MoviesScroll
//
//  Created by Mehmet ÖKSÜZ on 15.03.2023.
//

import UIKit

class SearchCell: UITableViewCell {
    
    @IBOutlet weak var searchLabell: UILabel!
    @IBOutlet weak var searchOverview: UILabel!
    @IBOutlet weak var searchImdb: UILabel!
    @IBOutlet weak var searchImage: UIImageView!
    
    func configure(with result: Any) {
        if let movie = result as? Results {
            searchLabell.text = movie.original_title
            searchOverview.text = movie.overview
            let voteAverage = movie.vote_average
            searchImdb.text = String(format: "%.1f / 10 IMDb", voteAverage)
            
            if let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(movie.poster_path)") {
                searchImage.downloaded(from: imageUrl, contentMode: .scaleAspectFill)
            }
        } else if let tvShow = result as? TVResults {
            searchLabell.text = tvShow.originalName
            searchOverview.text = tvShow.overview
            let voteAverage = tvShow.vote_average
            searchImdb.text = String(format: "%.1f / 10 IMDb", voteAverage)
            
            if let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(tvShow.poster_path )") {
                searchImage.downloaded(from: imageUrl, contentMode: .scaleAspectFill)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
}
