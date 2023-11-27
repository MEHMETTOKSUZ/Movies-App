//
//  GenresMoviesCell.swift
//  MoviesScroll
//
//  Created by Mehmet ÖKSÜZ on 3.05.2023.
//

import UIKit

class GenresMoviesCell: UITableViewCell {
    
    @IBOutlet weak var genresMoviesImage: UIImageView!
    @IBOutlet weak var genresMoviesImdbLabel: UILabel!
    @IBOutlet weak var genresMoviesNameLabel: UILabel!
    @IBOutlet weak var genresMoviesOverviewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func configure(genres: MoviesCell.ViewModel) {
        if let image = genres.image {
            self.genresMoviesImage.downloaded(from: image)
        }
        self.genresMoviesImdbLabel.text = genres.imdb
        self.genresMoviesNameLabel.text = genres.name
        self.genresMoviesOverviewLabel.text = genres.overview
        
    }
   
}
