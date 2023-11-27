//
//  ReviewsVC.swift
//  MoviesScroll
//
//  Created by Mehmet ÖKSÜZ on 29.04.2023.
//

import UIKit

class ReviewsVC: UIViewController, UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var reviews = [Review]()
    var choosenMovieId = ""
    let emptyListView = UIView()
    let emptyLabel = UILabel()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        getReviews()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if reviews.count > 0 {
            tableView.backgroundView = nil
            return reviews.count
        } else {
            emptyLabel.text = "SONUÇ YOK"
            emptyLabel.font = UIFont(name: "Helvetica", size: 25)
            emptyLabel.textColor = UIColor.darkGray
            emptyLabel.textAlignment = .center
            emptyLabel.sizeToFit()
            emptyListView.addSubview(emptyLabel)
            emptyListView.center = view.center
            emptyLabel.center = CGPoint(x: emptyListView.bounds.midX, y: emptyListView.bounds.midY)
            tableView.separatorStyle = .none
            tableView.backgroundView = emptyListView
            
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as! ReviewTableViewCell
        let apiData = self.reviews[indexPath.row]
        cell.configure(with: apiData)
        return cell
    }
    
    func getReviews()  {
        guard let urlReview = URL(string: "https://api.themoviedb.org/3/movie/\(choosenMovieId)/reviews?api_key=\(LocaleKey.API_KEY)") else { return }
        
        activityIndicator.startAnimating()
        WebService().fetchMediaData(from: urlReview) {  (reviews: Result<ReviewsResponse, Error>) in
            switch reviews {
            case .success(let review):
                self.reviews = review.results
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

