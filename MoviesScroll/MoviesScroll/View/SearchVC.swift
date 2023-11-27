//
//  SearchVC.swift
//  MoviesScroll
//
//  Created by Mehmet ÖKSÜZ on 15.03.2023.
//

import UIKit
import Foundation

class SearchVC: UIViewController , UISearchBarDelegate , UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    let viewModel = SearchViewModel()
    let emptyLabel = UILabel()
    let emptyListView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emptyLabel.text = "SONUÇ YOK"
        emptyLabel.font = UIFont(name: "Helvetica", size: 25)
        emptyLabel.textColor = UIColor.darkGray
        emptyLabel.textAlignment = .center
        emptyLabel.sizeToFit()
        emptyListView.addSubview(emptyLabel)
        view.addSubview(searchBar)
        
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let query = searchBar.text, !query.isEmpty else {
            return
        }
        viewModel.search(query: query) { results in
            DispatchQueue.main.async {
                self.viewModel.searchResults = results
                self.tableView.reloadData()
                searchBar.resignFirstResponder()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.searchResults.isEmpty {
            emptyLabel.isHidden = false
            if emptyListView.superview == nil {
                view.addSubview(emptyListView)
                emptyListView.center = view.center
                emptyLabel.center = CGPoint(x: emptyListView.bounds.midX, y: emptyListView.bounds.midY)
            }
            return 0
        } else {
            emptyLabel.isHidden = true
            emptyListView.removeFromSuperview()
            return viewModel.searchResults.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SearchCell
        let result = viewModel.searchResults[indexPath.row]
        cell.configure(with: result)
        searchBar.resignFirstResponder()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let result = viewModel.searchResults[indexPath.row]
        
        if result is Results {
            viewModel.didSelectMovie(at: indexPath.row)
            performSegue(withIdentifier: "detailsFromSearch", sender: result)
        } else if result is TVResults {
            viewModel.didSelectTVShow(at: indexPath.row)
            performSegue(withIdentifier: "detailsFromSearch", sender: result)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsFromSearch" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let movie = viewModel.searchResults[indexPath.row] as? Results {
                    let destinationVC = segue.destination as! MoviesTableViewDetails
                    destinationVC.selectedMovieId = String(movie.id)
                    
                    destinationVC.updateFavorite = { [weak self] isFavorite in
                        self?.tableView.reloadData()
                        
                    }
                    
                    if let indexPath = tableView.indexPathForSelectedRow {
                        
                        destinationVC.selectedMovie = viewModel.searchResults[indexPath.row] as? Results
                        
                    }
                    
                } else if let tvShow = viewModel.searchResults[indexPath.row] as? TVResults {
                    let destinationVC = segue.destination as! MoviesTableViewDetails
                    destinationVC.selectedMovieId = String(tvShow.id)
                    
                    destinationVC.updateFavorite = { [weak self] isFavorite in
                        self?.tableView.reloadData()
                        
                    }
                    
                    if let indexPath = tableView.indexPathForSelectedRow {
                        
                        destinationVC.selectedMovie = viewModel.searchResults[indexPath.row] as? Results
                        
                    }
                }
            }
        }
    }
}



