//
//  TVDetailsVC.swift
//  MoviesScroll
//
//  Created by Mehmet ÖKSÜZ on 24.02.2023.
//

import UIKit

class TVShowsDetails: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    struct TvShowGneresViewModel {
        let genres: String
    }
    
    struct TvShowCrewsViewModel {
        let directors: String
        let productors: String
        let writers: String
    }
    
    struct TvShowVideoViewModel {
        let key: String
    }
    
    @IBOutlet weak var tvShowDetailsImageView: UIImageView!
    @IBOutlet weak var tvShowDetailsNameLabel: UILabel!
    @IBOutlet weak var tvShowDetailsOverviewLabel: UILabel!
    @IBOutlet weak var tvShowDetailsImdbLabel: UILabel!
    @IBOutlet weak var writersLabel: UILabel!
    @IBOutlet weak var producersLabel: UILabel!
    @IBOutlet weak var directorsLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var detailsFavoriteButtonOutlet: UIButton!
    @IBOutlet weak var tvShowDetailsGenresLabel: UILabel!
    @IBOutlet weak var tvShowDetailFirstAirDateLabel: UILabel!
    
    var selectedMovieId = ""
    var videoKey = ""
    var selectedTVShow: TVResults?
    var videos = [TvShowVideo]()
    var genres = [Genre]()
    var updateFavorite: ((Bool) -> (Void))?
    var castViewModel: CastViewModel?
    var genresViewModel = GenresViewModel()
    let crewViewModel = CreditsViewModel()
    let videoViewModel = VideosViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        isFvorite()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateFavoriteStatus), name: NSNotification.Name("newTvShowAdded"), object: nil)
        
        
        castViewModel = CastViewModel(selectedMovieId: selectedMovieId)
        castViewModel?.getCastTvShow()
        castViewModel?.didFinishLoad = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
        genresViewModel = GenresViewModel()
        genresViewModel.fetchTvShowGenre(tvShowId: selectedMovieId)
        genresViewModel.didFinishLoad = {
            DispatchQueue.main.async {
                 let joinedGenres = self.genresViewModel.tvShowGenres
                    self.configureGenres(result: joinedGenres)
                
            }
        }
        
        crewViewModel.fetchTvCrew(movieId: selectedMovieId)
        crewViewModel.didFinishLoad = {
            DispatchQueue.main.async {
                if let crews = self.crewViewModel.configureTvCrews() {
                    self.configureCrew(result: crews)
                }
            }
        }
        
        videoViewModel.getTvVideos(videoId: selectedMovieId)
        videoViewModel.didFininshLoad = {
            DispatchQueue.main.async {
                if let videoKey = self.videoViewModel.configureTvVideos() {
                    self.videoKey = videoKey.key
                }
            }
        }
   
        tvShowDetailsNameLabel.text = selectedTVShow?.originalName
        tvShowDetailsOverviewLabel.text = selectedTVShow?.overview
        tvShowDetailFirstAirDateLabel.text = selectedTVShow?.first_air_date
        if let imdbRating = selectedTVShow?.vote_average {
            let imdbString = String(format: "%.1f / 10 IMDb", imdbRating)
            tvShowDetailsImdbLabel.text = imdbString
        }
        if let url = URL(string: "https://image.tmdb.org/t/p/w500\(selectedTVShow?.poster_path ?? "")") {
            
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.tvShowDetailsImageView.image = image
                    }
                } else {
                    self.makeAlert(titleInput: "Bildirim", messageInput: "Veri yüklenemedi Lütfen farklı bir film seçin")
                }
            }
        }
    }
    
    func configureGenres(result: [TVShowsDetails.TvShowGneresViewModel]) {
        let joinedGenres = result.map { $0.genres}.joined(separator: ", ")
        self.tvShowDetailsGenresLabel.text = joinedGenres
        
    }
    
    func configureCrew(result: TVShowsDetails.TvShowCrewsViewModel) {
        directorsLabel.text = result.directors
        producersLabel.text = result.productors
        writersLabel.text = result.writers
        
    }
  
    @objc func updateFavoriteStatus() {
        guard let selectedTVShow = selectedTVShow else { return }
        let isFavorite = FavoriteManager.shared.isTVShowFavorite(selectedTVShow)
        
        if isFavorite {
            detailsFavoriteButtonOutlet.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            detailsFavoriteButtonOutlet.setImage(UIImage(systemName: "star"), for: .normal)
        }
        
        updateFavorite?(isFavorite)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return castViewModel?.numberOfTvShowCast ?? Int(0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TVShowCastCell", for: indexPath) as! TVShowsCastCell
        if let viewModel = castViewModel {
            let cast = viewModel.castTvShow(at: indexPath.row)
            cell.configure(casting: cast)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 130, height: 300)
        
    }
    
    @IBAction func favoriteButtonClicked(_ sender: Any) {
        
        guard let selectedTVShow = selectedTVShow else { return }
        FavoriteManager.shared.toggleFavoriteTVShow(selectedTVShow)
        let isFavorite = FavoriteManager.shared.isTVShowFavorite(selectedTVShow)
        
        if isFavorite {
            detailsFavoriteButtonOutlet.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            detailsFavoriteButtonOutlet.setImage(UIImage(systemName: "star"), for: .normal)
        }
        updateFavorite?(isFavorite)
    }
    
    @IBAction func tvFragmanClicked(_ sender: Any) {
        playVideo(videoKey: videoKey)
        
    }
    func playVideo(videoKey: String) {
        
        let youtubeUrl = URL(string: "https://www.youtube.com/watch?v=\(videoKey)")!
        UIApplication.shared.open(youtubeUrl, options: [:], completionHandler: nil)
    }
    
    func makeAlert(titleInput: String , messageInput: String) {
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.cancel)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
    }
    func isFvorite() {
        
        
        if let storedFavoriteData = UserDefaults.standard.object(forKey: "favoriteTVShows") as? Data {
            let storedFavorites = try? JSONDecoder().decode([TVResults].self, from: storedFavoriteData)
            if storedFavorites != nil {
                if storedFavorites!.first(where: { $0.id == selectedTVShow!.id }) != nil {
                   self .detailsFavoriteButtonOutlet.setImage(UIImage(systemName: "star.fill"), for: .normal)
                    
                } else {
                    
                }
                
            } else {
                self.detailsFavoriteButtonOutlet.setImage(UIImage(systemName: "star"), for: .normal)
                
            }
        }
    }
}
