//
//  ViewController.swift
//  MoviesScroll
//
//  Created by Mehmet ÖKSÜZ on 20.12.2022.
//

import UIKit


class MoviesVC: UIViewController ,UITableViewDelegate , UITableViewDataSource , UIScrollViewDelegate , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var genresButton: UIBarButtonItem!
    
    let moviesViewModel = MoviesViewModel()
    var selectedCollectionViewMovie: Results?
    let collectionHeaderView = TableHeaderView().collectionView
    lazy var activityIndicatorView = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = searchButton
        navigationItem.leftBarButtonItem = genresButton
        
        let headerView = TableHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 350))
        headerView.collectionView.delegate = self
        headerView.collectionView.dataSource = self
        tableView.tableHeaderView = headerView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        collectionHeaderView?.reloadData()
        activityIndicatorView.center = view.center
        view.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        NotificationCenter.default.addObserver(self, selector: #selector(upgradeData), name: NSNotification.Name(rawValue: "upgradeData"), object: nil)
        
        moviesViewModel.fetchMediaData()
        moviesViewModel.fetchUpcomingMovies()
        moviesViewModel.didFinishLoad = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                headerView.collectionView.reloadData()
                FavoriteManager.shared.loadFavoriteMovies()
            }
        }
        
        activityIndicatorView.stopAnimating()
        
    }
    
    @objc func upgradeData() {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return moviesViewModel.numberOfMovies
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! MoviesCell
        cell.selectionStyle = .none
        cell.layer.cornerRadius = 10
        cell.favoriteButton.tag = indexPath.row
        cell.configure(movie: moviesViewModel.movie(at: indexPath.row))
     
        cell.favoritButtonClicked = {
             let movie = self.moviesViewModel.movie(at: indexPath.row)
            FavoriteManager.shared.toggleFavoriteMovie(movie.data)
                cell.configure(movie: movie)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedMovie = moviesViewModel.movie(at: indexPath.row)
            performSegue(withIdentifier: "toDetailsVCFromTable", sender: selectedMovie)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDetailsVCFromTable" {
            if let destinationVC = segue.destination as? MoviesTableViewDetails {
                if let indexPath = tableView.indexPathForSelectedRow {
                    let selectedMovie = moviesViewModel.movies[indexPath.row].data
                   
                    destinationVC.selectedMovieId = String(selectedMovie.id)
                    
                    destinationVC.updateFavorite = { [weak self] isFavorite in
                        self?.tableView.reloadData()
                    }
                    
                    destinationVC.selectedMovie = selectedMovie
                }
            }
        }
        
        if segue.identifier == "toDetailsVCFromCollection" {
            let destinationVC = segue.destination as! MoviesTableViewDetails
            
            if let selectedUpcomingMovies = selectedCollectionViewMovie {
          
               destinationVC.selectedMovieId = String(selectedUpcomingMovies.id)
                destinationVC.updateFavorite = { [weak self] isFavorite in
                    self?.collectionHeaderView?.reloadData()
                }
                if let selectedMovie = selectedCollectionViewMovie {
                    destinationVC.selectedMovie = selectedMovie
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let apiUpData = moviesViewModel.getUpcomingMovie(at: indexPath.row)
        let url = apiUpData.image
        (cell as? UpcomingMoviesHeaderCell)?.imageView.downloaded(from: url!, contentMode: .scaleToFill)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = moviesViewModel.getUpcomingMovie(at: indexPath.row)
        selectedCollectionViewMovie = selectedMovie.data
        performSegue(withIdentifier: "toDetailsVCFromCollection", sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return moviesViewModel.numberOfUpcomingMovies
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCollectionViewCell", for: indexPath) as! UpcomingMoviesHeaderCell
        cell.configure(movie: moviesViewModel.getUpcomingMovie(at: indexPath.row))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 300)
    }
    
    @IBAction func searchButonClicked(_ sender: Any) {
        performSegue(withIdentifier: "fromMoviesToSearchVC", sender: nil)
        
    }
    
    @IBAction func genresButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "toGenresVCFromMovies", sender: nil)
        
    }
}


