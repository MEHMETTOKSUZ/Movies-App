//
//  FavoriteFeedVC.swift
//  MoviesScroll
//
//  Created by Mehmet ÖKSÜZ on 20.12.2022.
//

import UIKit

class FavoriteVC: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let favoriteViewModel = FavoriteViewModel()
    var favoriteMovies = [Results]()
    var favoriteTVShows = [TVResults]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        loadedFavoriteDataMovies()
        loadedFavoriteDataTVShows()
        segmentController.addTarget(self, action: #selector(segmentControllerClicked(_:)), for: .valueChanged)
        
    }
    
    @IBAction func segmentControllerClicked(_ sender: UISegmentedControl) {
        
        FavoriteManager.shared.loadFavoriteMovies()
        FavoriteManager.shared.loadFavoriteTVShows()
        loadedFavoriteDataMovies()
        loadedFavoriteDataTVShows()
        collectionView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(loadedFavoriteDataMovies), name: NSNotification.Name(rawValue: "newMoviesAdded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadedFavoriteDataTVShows), name: NSNotification.Name(rawValue: "newTvShowAdded"), object: nil)
        
    }
    
    @objc func loadedFavoriteDataMovies() {
        
        favoriteViewModel.loadFavoriteMovies()
        favoriteViewModel.didFinishLoad = { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    @objc func loadedFavoriteDataTVShows() {
        
        favoriteViewModel.loadFavoriteTVShows()
        favoriteViewModel.didFinishLoad = { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if segmentController.selectedSegmentIndex == 0 {
            return favoriteViewModel.numberOfMovies
        } else {
            return favoriteViewModel.numberOfTVShows
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoriteCell", for: indexPath) as! FavoriteCell
        if segmentController.selectedSegmentIndex == 0 {
            cell.configure(movie: favoriteViewModel.getFavoriteMovies(at: indexPath.row))
        } else {
            cell.configureTvShow(tvShow: favoriteViewModel.getFavoriteTVShows(at: indexPath.row))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.bounds.width
        let cellSize = width / 2 - 15
        return CGSize(width: cellSize, height: cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if segmentController.selectedSegmentIndex == 0 {
             let selectedMovies = favoriteViewModel.getFavoriteMovies(at: indexPath.row)
                performSegue(withIdentifier: "toDetailsVCFromFavorite", sender: selectedMovies)
            
        } else {
             let selectedTVShow = favoriteViewModel.getFavoriteTVShows(at: indexPath.row)
                performSegue(withIdentifier: "toTVDetailsVCFromFavorite", sender: selectedTVShow)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier,
              let indexPath = collectionView.indexPathsForSelectedItems?.first else { return }
        
        if identifier == "toDetailsVCFromFavorite" {
            let destinationVC = segue.destination as! MoviesTableViewDetails
            let favoriteData = favoriteViewModel.favoriteMovies[indexPath.row].data
        
            destinationVC.selectedMovieId = String(favoriteData.id)
       
            destinationVC.selectedMovie = favoriteData
            destinationVC.updateFavorite = { isFavorite in
                self.collectionView.reloadData()
            }
        } else if identifier == "toTVDetailsVCFromFavorite" {
            let destinationVC = segue.destination as! TVShowsDetails
            let favoriteData = favoriteViewModel.favoriteTVShows[indexPath.row].data
          
            destinationVC.selectedMovieId = String(favoriteData.id)
            
            destinationVC.selectedTVShow = favoriteData
            destinationVC.updateFavorite = { isFavorite in
                self.collectionView.reloadData()
            }
        }
    }
}

