//
//  ReviewTableViewCell.swift
//  MoviesScroll
//
//  Created by Mehmet ÖKSÜZ on 29.04.2023.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var reviewImage: UIImageView!
    @IBOutlet weak var reviewComment: UILabel!
    @IBOutlet weak var reviewName: UILabel!
    @IBOutlet weak var reviewDateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with review: Review) {
           reviewComment.text = review.content
           reviewName.text = review.author
           let isoDate = review.updated_at
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
           if let date = dateFormatter.date(from: isoDate) {
               dateFormatter.dateFormat = "dd/MM/yy HH:mm"
               let dateString = dateFormatter.string(from: date)
               reviewDateLabel.text = dateString
           }
       }

}
