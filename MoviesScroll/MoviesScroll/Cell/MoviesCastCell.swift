//
//  MoviesCastCell.swift
//  MoviesScroll
//
//  Created by Mehmet ÖKSÜZ on 2.03.2023.
//

import UIKit

class MoviesCastCell: UICollectionViewCell {
    
    struct ViewModel {
        let id: Int
        let image: URL?
        let name: String
        let data: Cast
    }
    
    @IBOutlet weak var castingImage: UIImageView!
    @IBOutlet weak var castNameLabel: UILabel!
    
    func configure(credits: ViewModel) {
        if let image = credits.image {
            self.castingImage.downloaded(from: image, contentMode: .scaleToFill)
        }
        self.castNameLabel.text = credits.name
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
