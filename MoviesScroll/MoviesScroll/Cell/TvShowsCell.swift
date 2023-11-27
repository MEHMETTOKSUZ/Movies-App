//
//  TvCollectionCell.swift
//  MoviesScroll
//
//  Created by Mehmet ÖKSÜZ on 25.02.2023.
//

import UIKit

class TvShowsCell: UICollectionViewCell {
    
    struct ViewModel {
        let id: Int
        let name: String
        let image: URL?
        let imdb: String
        let overview: String
        let data: TVResults
    }
    
    @IBOutlet weak var topTVShowNameLabel: UILabel!
    @IBOutlet weak var topTVShowImage: UIImageView!
    @IBOutlet weak var topTVShowImdbLabel: UILabel!
    @IBOutlet weak var popularTVShowNameLabel: UILabel!
    @IBOutlet weak var popularTVShowImdbLabel: UILabel!
    @IBOutlet weak var popularTVShowImage: UIImageView!
    
    
    func configureTop(topRated: ViewModel) {
        self.topTVShowNameLabel.text = topRated.name
        if let image = topRated.image {
            self.topTVShowImage.downloaded(from: image, contentMode: .scaleToFill)
            topTVShowImdbLabel.text = topRated.imdb
        }
    }
    
    func configurePopular(popular: ViewModel) {
        self.popularTVShowNameLabel.text = popular.name
        self.popularTVShowImdbLabel.text = popular.imdb
        if let image = popular.image {
            self.popularTVShowImage.downloaded(from: image, contentMode: .scaleToFill)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}
