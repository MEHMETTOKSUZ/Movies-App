//
//  FeedDetails.swift
//  MoviesScroll
//
//  Created by Mehmet ÖKSÜZ on 20.12.2022.
//

import UIKit


class MoviesTableViewDetails: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource  {
    
    struct GenreViewModel {
        let genres: String
    }
    
    struct CrewsViewModel {
        let directors: String
        let writers: String
        let productor: String
    }
    
    struct DetailViewModel {
        let runTime: Int
        let homePage: String
    }
    
    struct VideoViewModel {
        let key: String
    }
   
    
    @IBOutlet weak var movieDetailsImage: UIImageView!
    @IBOutlet weak var movieDetailsNameLabel: UILabel!
    @IBOutlet weak var movieDetailsOverviewLabel: UILabel!
    @IBOutlet weak var movieDetailsimdb: UILabel!
    @IBOutlet weak var detailsFavoriteButtonOutlet: UIButton!
    @IBOutlet weak var producersLabel: UILabel!
    @IBOutlet weak var writersLabel: UILabel!
    @IBOutlet weak var directorsLabel: UILabel!
    @IBOutlet weak var fragmanButton: UIButton!
    @IBOutlet weak var castingImageCollection: UICollectionView!
    @IBOutlet weak var movieDetailsGenresLabel: UILabel!
    @IBOutlet weak var MovieDetailsRunTimeLabel: UILabel!
    @IBOutlet weak var AddCartButtonOutlet: UIButton!
    @IBOutlet weak var MovieDetailsHomePageLabel: UILabel!
    @IBOutlet weak var movieDetailsDateLabel: UILabel!
    
    var selectedMovieId = ""
    var videoKey = ""
    var selectedMovie: Results?
    var updateFavorite: ((Bool) -> (Void))?
    var castViewModel: CastViewModel?
    var genresViewModel: GenresViewModel?
    let crewViewModel = CreditsViewModel()
    let detailViewModel = MovieDetailsViewModel()
    let videoViewModel = VideosViewModel()

    lazy var activityIndicatorView = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castingImageCollection.delegate = self
        castingImageCollection.dataSource = self
        castingImageCollection.reloadData()
        MovieDetailsHomePageLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(homePageLabelTapped))
        MovieDetailsHomePageLabel.addGestureRecognizer(tapGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(updateFavoriteStatus), name: NSNotification.Name("newMoviesAdded"), object: nil)
        
         activityIndicatorView.center = CGPoint(x: 200, y: 300)
         view.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        
        castViewModel = CastViewModel(selectedMovieId: selectedMovieId)
        castViewModel?.getCast()
        castViewModel?.didFinishLoad = { [weak self] in
            DispatchQueue.main.async {
                self?.castingImageCollection.reloadData()
            }
        }
   
        detailViewModel.fetchMovieDetails(movieId: selectedMovieId)
        detailViewModel.didFinishLoad = { [weak self] in
            DispatchQueue.main.async {
                if let details = self?.detailViewModel.details {
                    for detail in details {
                        self?.configureDetails(result: detail)
                    }
                }
            }
        }
        
        genresViewModel = GenresViewModel()
        genresViewModel?.fetchGenres(movieId: selectedMovieId)
        genresViewModel?.didFinishLoad = { [weak self] in
            DispatchQueue.main.async {
                if let joinedGenres = self?.genresViewModel?.genres {
                    self?.configureGenres(result: joinedGenres)
                }
            }
        }
       crewViewModel.fetchCredits(movieId: selectedMovieId)
        crewViewModel.didFinishLoad = { [weak self] in
            DispatchQueue.main.async {
                if let crewsViewModel = self?.crewViewModel.configureCrews() {
                    self?.configureCrew(result: crewsViewModel)
                }
            }
        }
        
        videoViewModel.getVideos(videoId: selectedMovieId)
        videoViewModel.didFininshLoad = { [weak self] in
            DispatchQueue.main.async {
                if let videoViewModel = self?.videoViewModel.configureVideos() {
                    self?.videoKey = videoViewModel.key
                }
            }
        }
        
        if let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(selectedMovie?.poster_path ?? "")") {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: imageUrl) {
                    DispatchQueue.main.async {
                        self.movieDetailsImage.image = UIImage(data: data)
                        self.activityIndicatorView.stopAnimating()
                    }
                }
            }
        }
        movieDetailsNameLabel.text = selectedMovie?.original_title
        movieDetailsDateLabel.text = selectedMovie?.release_date
        if let imdbRatingDouble = selectedMovie?.vote_average {
            let imdbRating = String(format: "%.1f / 10 IMDb", imdbRatingDouble)
            movieDetailsimdb.text = imdbRating
        } else {
          
        }
        movieDetailsOverviewLabel.text = selectedMovie?.overview
        isFavorite()
        isRent()
        isPurchased()
        isCart()
 
    }
    
    func configureCrew(result: MoviesTableViewDetails.CrewsViewModel) {
        self.directorsLabel.text = result.directors
        self.producersLabel.text = result.productor
        self.writersLabel.text = result.writers
        
    }
    
    func configureGenres(result: [MoviesTableViewDetails.GenreViewModel]) {
        let joinedGenres = result.map { $0.genres }.joined(separator: ", ")
        self.movieDetailsGenresLabel.text = joinedGenres
    }
    
    func configureDetails(result: MoviesTableViewDetails.DetailViewModel) {
        
        self.MovieDetailsRunTimeLabel.text = String("\(result.runTime) dakika" )
        self.MovieDetailsHomePageLabel.text = result.homePage
    }
  
 
    @objc func homePageLabelTapped() {
        guard let urlString = MovieDetailsHomePageLabel.text, let url = URL(string: urlString) else {
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc func updateFavoriteStatus() {
        guard let selectedMovie = selectedMovie else { return }
        let isFavorite = FavoriteManager.shared.isMovieFavorite(selectedMovie)
        if isFavorite {
            detailsFavoriteButtonOutlet.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            detailsFavoriteButtonOutlet.setImage(UIImage(systemName: "star"), for: .normal)
        }
        updateFavorite?(isFavorite)
    }
 

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return castViewModel?.numberOfCast ?? Int(0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoviesCastCell", for: indexPath) as! MoviesCastCell
        if let viewModel = castViewModel {
            let cast = viewModel.cast(at: indexPath.row)
            cell.configure(credits: cast)
        }
     
        return cell
    }
    
    @IBAction func favoriteClicked(_ sender: Any) {
        guard let selectedMovie = selectedMovie else { return }
        FavoriteManager.shared.toggleFavoriteMovie(selectedMovie)
        let isFavorite = FavoriteManager.shared.isMovieFavorite(selectedMovie)
        if isFavorite {
            detailsFavoriteButtonOutlet.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            detailsFavoriteButtonOutlet.setImage(UIImage(systemName: "star"), for: .normal)
        }
        
        updateFavorite?(isFavorite)
        NotificationCenter.default.post(name: NSNotification.Name("upgradeData"), object: nil)
    }
    
    @IBAction func AddCartButtonClicked(_ sender: Any) {
        guard let selectedMovie = selectedMovie else {return}
        CartManager.shared.togglePurchaseMovie(selectedMovie)
        let isPurchase = CartManager.shared.isMoviePurchase(selectedMovie)
        if isPurchase {
            AddCartButtonOutlet.setTitle("Sepette", for: .normal)
        } else {
            AddCartButtonOutlet.setTitle("Ekle", for: .normal)
        }
    }
    
    @IBAction func fragmanClicked(_ sender: Any) {
        var isPurchased = false
        var isRented = false
        if let purchaseData = UserDefaults.standard.object(forKey: "PurchasedMovies") as? Data {
            let purchased = try? JSONDecoder().decode([Results].self, from: purchaseData)
            if let selectedMovie = selectedMovie, let purchasedMovies = purchased {
                if purchasedMovies.contains(where: { $0.id == selectedMovie.id }) {
                    isPurchased = true
                }
            }
        }
        
        if let rentData = UserDefaults.standard.object(forKey: "RentMovies") as? Data {
            let rented = try? JSONDecoder().decode([Results].self, from: rentData)
            if let selectedMovie = selectedMovie, let rentedMovies = rented {
                if rentedMovies.contains(where: { $0.id == selectedMovie.id }) {
                    isRented = true
                }
            }
        }
        if isPurchased || isRented {
            playVideo(videoKey: videoKey)
        } else {
            makeAlert(titleInput: "Bildirim", messageInput: "Lütfen izlemek istediğiniz filmi satın alın ya da kiralayın")
        }
    }
    
    func playVideo(videoKey: String) {
        let youtubeUrl = URL(string: "https://www.youtube.com/watch?v=\(videoKey)")!
        UIApplication.shared.open(youtubeUrl, options: [:], completionHandler: nil)
    }
    
    @IBAction func reviewButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "toReviewsVC", sender: selectedMovieId)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toReviewsVC" {
            if let destinationVC = segue.destination as? ReviewsVC {
                destinationVC.choosenMovieId = selectedMovieId
            }
        }
    }
    
    func makeAlert(titleInput: String , messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.cancel)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func isFavorite() {
        if let storedFavoriteData = UserDefaults.standard.object(forKey: "favoriteMovies") as? Data {
            let storedFavorites = try? JSONDecoder().decode([Results].self, from: storedFavoriteData)
            if storedFavorites != nil {
                if storedFavorites!.first(where: { $0.id == selectedMovie?.id }) != nil {
                    detailsFavoriteButtonOutlet.setImage(UIImage(systemName: "star.fill"), for: .normal)
                    
                } else {
                }
            } else {
            detailsFavoriteButtonOutlet.setImage(UIImage(systemName: "star"), for: .normal)
                
            }
        } else {
            print("ERROR: Unable to retrieve stored favorite data")
        }
    }
    
    func isRent() {
        if let storedRentData = UserDefaults.standard.object(forKey: "RentMovies") as? Data {
            let storedRent = try? JSONDecoder().decode([Results].self, from: storedRentData)
            if storedRent != nil {
                if storedRent!.first(where: { $0.id == selectedMovie!.id }) != nil {
                    AddCartButtonOutlet.isHidden = true
                }
            } else {
              AddCartButtonOutlet.isHidden = true
            }
        }
    }
    
    func isPurchased() {
        if let storedPurchaseData = UserDefaults.standard.object(forKey: "PurchasedMovies") as? Data {
            let storedPurchased = try? JSONDecoder().decode([Results].self, from: storedPurchaseData)
            if storedPurchased != nil {
                if storedPurchased!.first(where: { $0.id == selectedMovie!.id }) != nil {
                    AddCartButtonOutlet.isHidden = true
                } else {
                    print("Error")
                }
            } else {
                  AddCartButtonOutlet.isHidden = false
            }
        }
    }
    
    func isCart() {
        if let storedCartData = UserDefaults.standard.object(forKey: "AddedCartMovies") as? Data {
            let storedCart = try? JSONDecoder().decode([Results].self, from: storedCartData)
            if storedCart != nil {
                if storedCart!.first(where: { $0.id == selectedMovie!.id }) != nil {
                    AddCartButtonOutlet.setTitle("Sepette", for: .normal)
                }
            } else {
                makeAlert(titleInput: "Bildirim", messageInput: "Lütfen izlemek istediğiniz filmi satın alın ya da kiralayın")
                AddCartButtonOutlet.setTitle("Ekle", for: .normal)
            }
        }
    }
}


    
    
