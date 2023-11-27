//
//  TVShowsCastCell.swift
//  MoviesScroll
//
//  Created by Mehmet ÖKSÜZ on 17.03.2023.
//

import UIKit

class TVShowsCastCell: UICollectionViewCell {
    
    struct TvShowCastViewModel {
        let id: Int
        let image: URL?
        let name: String
        let data: Cast
        
    }
    
    @IBOutlet weak var tvShowImageView: UIImageView!
    @IBOutlet weak var tvShowCastName: UILabel!
    
    func configure(casting: TvShowCastViewModel) {
        if let image = casting.image {
            self.tvShowImageView.downloaded(from: image, contentMode: .scaleToFill)
        }
        self.tvShowCastName.text = casting.name
    }
}
