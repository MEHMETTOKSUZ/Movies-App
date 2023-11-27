//
//  TVCollectionVC.swift
//  MoviesScroll
//
//  Created by Mehmet ÖKSÜZ on 25.02.2023.
//

import UIKit

class TVShowsVC: UIViewController , UICollectionViewDelegate ,  UICollectionViewDataSource {
    
    
    @IBOutlet weak var topRatedCollectionView: UICollectionView!
    @IBOutlet weak var popularCollectionView: UICollectionView!
    
    var tvTopRated = [TVResults]()
    var tvPopuler = [TVResults]()
    let tvShowViewModel = TVShowsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topRatedCollectionView.delegate = self
        popularCollectionView.delegate = self
        topRatedCollectionView.dataSource = self
        popularCollectionView.dataSource = self
        
        tvShowViewModel.fetchTvTopRated()
        tvShowViewModel.fetchTVPopular()
        tvShowViewModel.didFinishLoad = { [weak self] in
            DispatchQueue.main.async {
                self?.topRatedCollectionView.reloadData()
                self?.popularCollectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == topRatedCollectionView {
            return tvShowViewModel.numberOfToprated
            
        } else if collectionView == popularCollectionView {
            return tvShowViewModel.numberOfPopular
            
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TvCollectionCell", for: indexPath) as! TvShowsCell
        
        if collectionView == topRatedCollectionView {
            cell.configureTop(topRated: tvShowViewModel.getTopRated(at: indexPath.row))
            
        } else if collectionView == popularCollectionView {
            cell.configurePopular(popular: tvShowViewModel.getPopular(at: indexPath.row))
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTvDetailsTop" {
            
            let destinationVC = segue.destination as! TVShowsDetails
            if let indexPath = topRatedCollectionView.indexPathsForSelectedItems?.first {
                let topratedData = tvShowViewModel.tvTopRated[indexPath.row].data
                destinationVC.selectedMovieId = String(topratedData.id)
            }
            
            if let indexPath = topRatedCollectionView.indexPathsForSelectedItems?.first {
                destinationVC.selectedTVShow = tvShowViewModel.tvTopRated[indexPath.row].data
            }
        }
        
        if segue.identifier == "toTvDetailsPopuler" {
            
            let destinationVC = segue.destination as! TVShowsDetails
            if let indexPath = popularCollectionView.indexPathsForSelectedItems?.first {
                let topratedData = tvShowViewModel.tvPopuler[indexPath.row].data
              
                destinationVC.selectedMovieId = String(topratedData.id)
            }
            
            if let indexPath = popularCollectionView.indexPathsForSelectedItems?.first {
                destinationVC.selectedTVShow = tvShowViewModel.tvPopuler[indexPath.row].data
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == topRatedCollectionView {
             let selectedTopRated =  tvShowViewModel.getTopRated(at: indexPath.row)
                performSegue(withIdentifier: "toTvDetailsTop", sender: selectedTopRated)
            
            
        } else if collectionView == popularCollectionView {
            let selectedPopular = tvShowViewModel.getPopular(at: indexPath.row)
                performSegue(withIdentifier: "toTvDetailsPopuler", sender: selectedPopular)
            
        }
    }
}

