//
//  GenresVC.swift
//  MoviesScroll
//
//  Created by Mehmet ÖKSÜZ on 1.05.2023.
//

import UIKit

class GenresVC: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var genres = ["Aksiyon", "Korku", "Dram", "Komedi", "Savaş", "Macera", "Animasyon", "Fantastik", "Romantik", "Bilim Kurgu", "Aile", "Gizem"]
    var genresImages = [
        "Aksiyon": UIImage(named: "Aksiyon")!,
        "Korku": UIImage(named: "Korku")!,
        "Dram": UIImage(named: "Dram")!,
        "Komedi": UIImage(named: "Komedi")!,
        "Savaş": UIImage(named: "Savaş")!,
        "Macera": UIImage(named: "Macera")!,
        "Animasyon": UIImage(named: "Animasyon")!,
        "Fantastik": UIImage(named: "Fantastik")!,
        "Romantik": UIImage(named: "Romantik")!,
        "Bilim Kurgu": UIImage(named: "Bilim Kurgu")!,
        "Aile": UIImage(named: "Aile")!,
        "Gizem": UIImage(named: "Gizem")!]
    
    var selectedGenre: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  genres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GenresCell", for: indexPath) as! GenresCell
        cell.selectionStyle = .none
        let genre = genres[indexPath.row]
        let image = genresImages[genre]
        cell.configureCell(genre: genre, image: image)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let genre = genres[indexPath.row]
        let genresMoviesVC = storyboard?.instantiateViewController(withIdentifier: "GenresMoviesFromGenres") as? GenresMoviesVC
        genresMoviesVC?.genre = genre
        navigationController?.pushViewController(genresMoviesVC!, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGenresMoviesFromGenres" {
            let destinationVC = segue.destination as! GenresMoviesVC
            destinationVC.genre = selectedGenre
        }
    }
}
