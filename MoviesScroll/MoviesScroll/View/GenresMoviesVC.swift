//
//  GenresMoviesVC.swift
//  MoviesScroll
//
//  Created by Mehmet ÖKSÜZ on 3.05.2023.
//

import UIKit

class GenresMoviesVC: UIViewController, UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var genre: String?
    var viewModel: GenresMoviesViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigation()
        viewModel = GenresMoviesViewModel(genre: genre)
        viewModel?.fetchMovies()
        viewModel?.didFinishLoad = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfMovies ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GenresMoviesCell", for: indexPath) as! GenresMoviesCell
        
        if let movieViewModel = viewModel?.getMovie(at: indexPath.row) {
            cell.configure(genres: movieViewModel)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let selectedMovie = viewModel?.getMovie(at: indexPath.row)
            performSegue(withIdentifier: "toDetailsFromGenresMovies", sender: selectedMovie)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsFromGenresMovies",
           let destinationVC = segue.destination as? MoviesTableViewDetails,
           let indexPath = tableView.indexPathForSelectedRow,
           let selectedMovie = viewModel?.getMovie(at: indexPath.row).data {
           
            destinationVC.selectedMovieId = String(selectedMovie.id)
            
            destinationVC.updateFavorite = { [weak self] isFavorite in
                self?.tableView.reloadData()
            }
            
            destinationVC.selectedMovie = selectedMovie
        }
    }
    
    func navigation() {
        
        switch genre {
        case "Aksiyon":
            self.navigationItem.title = "Aksiyon"
        case "Korku":
            self.navigationItem.title = "Korku"
        case "Dram":
            self.navigationItem.title = "Dram"
        case "Komedi":
            self.navigationItem.title = "Komedi"
        case "Savaş":
            self.navigationItem.title = "Savaş"
        case "Macera":
            self.navigationItem.title = "Macera"
        case "Animasyon":
            self.navigationItem.title = "Animasyon"
        case "Fantastik":
            self.navigationItem.title = "Fantastik"
        case "Romantik":
            self.navigationItem.title = "Romantik"
        case "Bilim Kurgu":
            self.navigationItem.title = "Bilim Kurgu"
        case "Aile":
            self.navigationItem.title = "Aile"
        case "Gizem":
            self.navigationItem.title = "Gizem"
        default:
            break
        }
    }
}
