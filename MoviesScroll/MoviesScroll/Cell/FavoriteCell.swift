//
//  FavoriteCell.swift
//  MoviesScroll
//
//  Created by Mehmet ÖKSÜZ on 20.12.2022.
//

import UIKit

class FavoriteCell: UICollectionViewCell {
    
    @IBOutlet weak var favoriteMoviesImage: UIImageView!
    
    func configure(movie: MoviesCell.ViewModel) {
        if let image = movie.image {
            self.favoriteMoviesImage.downloaded(from: image, contentMode: .scaleToFill)
        }
    }
    
    func configureTvShow(tvShow: TvShowsCell.ViewModel) {
        if let image = tvShow.image {
            self.favoriteMoviesImage.downloaded(from: image, contentMode: .scaleToFill)
        }
    }
 
    override func awakeFromNib() {
        super.awakeFromNib()
        favoriteMoviesImage.layer.cornerRadius = 10
    }
    
}
