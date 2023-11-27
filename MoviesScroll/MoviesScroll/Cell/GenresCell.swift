//
//  GenresCell.swift
//  MoviesScroll
//
//  Created by Mehmet ÖKSÜZ on 1.05.2023.
//

import UIKit

class GenresCell: UITableViewCell {

    @IBOutlet weak var genresImageView: UIImageView!
    @IBOutlet weak var genresLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    func configureCell(genre: String, image: UIImage?) {
        self.genresLabel.text = genre
        self.genresImageView.image = image
       }

}
