//
//  PurchasedCell.swift
//  MoviesScroll
//
//  Created by Mehmet ÖKSÜZ on 11.05.2023.
//

import UIKit

class PurchasedCell: UICollectionViewCell {
    
    
    @IBOutlet weak var purchaseReturnButtonOutlet: UIButton!
    @IBOutlet weak var purchasedMoviesName: UILabel!
    @IBOutlet weak var purchasedMoviesImage: UIImageView!
    
    var purchaseButtonClicked: (() -> ())?
   
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    @IBAction func purchaseReturnButtonClicked(_ sender: Any) {
        purchaseButtonClicked?()
        
    }
    func configure(purchased: MoviesCell.ViewModel) {
        self.purchasedMoviesName.text = purchased.name
        if let image = purchased.image {
            self.purchasedMoviesImage.downloaded(from: image, contentMode: .scaleToFill)

        }
    }
 
}
