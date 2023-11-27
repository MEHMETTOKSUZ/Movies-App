//
//  BasketCell.swift
//  MoviesScroll
//
//  Created by Mehmet ÖKSÜZ on 2.04.2023.
//

import UIKit

class CartCell: UITableViewCell {
    
    @IBOutlet weak var cartMovieImageView: UIImageView!
    @IBOutlet weak var cartMovieNameLabel: UILabel!
    @IBOutlet weak var cartMovieImdbLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        cartMovieImageView.layer.cornerRadius = 10
   
    }
    
    func configure(carts: MoviesCell.ViewModel) {
        if let image = carts.image {
            self.cartMovieImageView.downloaded(from: image, contentMode: .scaleToFill)
        }
        self.cartMovieNameLabel.text = carts.name
        self.cartMovieImdbLabel.text = carts.imdb
        
    }
 
}
