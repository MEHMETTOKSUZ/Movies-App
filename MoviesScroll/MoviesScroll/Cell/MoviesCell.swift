//
//  FeedCell.swift
//  MoviesScroll
//
//  Created by Mehmet ÖKSÜZ on 20.12.2022.
//

import UIKit

class MoviesCell: UITableViewCell {
    
    struct ViewModel: Encodable {
        let id: Int
        let overview: String
        let name: String
        let image: URL?
        let imdb: String
        let data: Results
        
        var isFavorited: Bool {
            FavoriteManager.shared.isMovieFavorite(data)
        }
    }
    
    @IBOutlet weak var movieOverviewLabel: UILabel!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieImdbLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var movieImdbImage: UIImageView!
    @IBOutlet weak var favoriteLabel: UILabel!
    
    var favoritButtonClicked : (() -> ())?
    
    func configure(movie: ViewModel) {
        self.movieOverviewLabel.text = movie.overview
        self.movieNameLabel.text = movie.name
        
        if let image = movie.image {
            self.movieImageView.downloaded(from: image, contentMode: .scaleToFill)
        } else {
            self.movieImageView.image = nil
        }
        
        self.movieImdbLabel.text = movie.imdb
        favoriteLabel.isHidden = !movie.isFavorited
        let imageName : String = movie.isFavorited ? "star.fill": "star"
        self.favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        favoriteLabel.isHidden = true
        movieNameLabel.textAlignment = .left
        movieNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        movieNameLabel.numberOfLines = 2
        movieImdbLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        movieImdbLabel.textAlignment = .left
        movieOverviewLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func favoriButton(_ sender: Any) {
        favoritButtonClicked?()

    }
    
}


