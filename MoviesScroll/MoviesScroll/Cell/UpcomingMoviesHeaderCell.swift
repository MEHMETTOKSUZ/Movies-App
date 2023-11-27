//
//  MyCollectionViewCell.swift
//  MoviesScroll
//
//  Created by Mehmet ÖKSÜZ on 11.03.2023.
//

import UIKit

class UpcomingMoviesHeaderCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    var collectionNameLabel: UILabel!
    var collectionImdbLabel: UILabel!
    var imdbImageView: UIImageView!
    
    func configure(movie: MoviesCell.ViewModel) {
        self.collectionNameLabel.text = movie.name
        
        if let image = movie.image {
            self.imageView.downloaded(from: image, contentMode: .scaleToFill)
        } else {
            self.imageView.image = nil
        }
        
        self.collectionImdbLabel.text = movie.imdb
      
    }
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionNameLabel = UILabel()
        collectionNameLabel.textAlignment = .left
        collectionNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        collectionNameLabel.numberOfLines = 2
        collectionNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        imdbImageView = UIImageView()
        imdbImageView.contentMode = .scaleAspectFit
        imdbImageView.image = UIImage(systemName: "star.fill")
        imdbImageView.tintColor = .systemOrange
        imdbImageView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionImdbLabel = UILabel()
        collectionImdbLabel.textAlignment = .left
        collectionImdbLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        collectionImdbLabel.numberOfLines = 1
        collectionImdbLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.addSubview(imageView)
        self.addSubview(collectionNameLabel)
        self.addSubview(imdbImageView)
        self.addSubview(collectionImdbLabel)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: collectionNameLabel.topAnchor, constant: -5),
            collectionNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imdbImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imdbImageView.topAnchor.constraint(equalTo: collectionNameLabel.bottomAnchor, constant: 5),
            imdbImageView.widthAnchor.constraint(equalToConstant: 15),
            imdbImageView.heightAnchor.constraint(equalToConstant: 15),
            collectionImdbLabel.leadingAnchor.constraint(equalTo: imdbImageView.trailingAnchor, constant: 5),
            collectionImdbLabel.centerYAnchor.constraint(equalTo: imdbImageView.centerYAnchor),
            
        ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

