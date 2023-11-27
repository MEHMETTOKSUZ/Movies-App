//
//  BasketVC.swift
//  MoviesScroll
//
//  Created by Mehmet ÖKSÜZ on 2.04.2023.
//

import UIKit

class CartVC: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = CartViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        loadedreceivedMovies()
        CartManager.shared.loadPurchaseMovies()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadedreceivedMovies), name: NSNotification.Name(rawValue: "newDataAdded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(emptyCart), name: NSNotification.Name("PurchasedSucces"), object: nil)
        updateBadgeValue()
    }
    
    @objc func loadedreceivedMovies() {
        
        viewModel.loadRecivedData()
        viewModel.didFinishLoad = { [weak self] in
            self?.tableView.reloadData()
            self?.updateBadgeValue()
        }
    }
    
    func updateBadgeValue() {
        
        if let receivedMoviesData = UserDefaults.standard.object(forKey: "AddedCartMovies") as? Data {
            let receivedMovies = try? JSONDecoder().decode([Results].self, from: receivedMoviesData)
            let count = receivedMovies?.count ?? 0
            
            self.tabBarItem.badgeValue = count > 0 ? String(count) : nil
            
            if let items = tabBarController?.tabBar.items {
                let item = items[3]
                item.badgeValue = count > 0 ? String(count) : nil
            }
        }
    }
    
    @objc func emptyCart() {
        
        viewModel.received.removeAll(keepingCapacity: false)
        tableView.reloadData()
    }
    
    @IBAction func buyButtonClicked(_ sender: Any) {
        
        if viewModel.received.count > 0 {
            performSegue(withIdentifier: "toPaymentVC", sender: nil)
            tableView.reloadData()
        } else {
            makeAlert(titleInput: "Bildirim", messageInput: "Sepetiniz Boş!")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.numberOfReceived
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        cell.configure(carts: viewModel.getReceived(at: indexPath.row))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Sil"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
             let movie = viewModel.getReceived(at: indexPath.row).data
                CartManager.shared.deletePurchaseMovie(movie)
                
                let userDefaults = UserDefaults.standard
                if var receivedMovies = UserDefaults.standard.object(forKey: "AddedCartMovies") as? [Results] {
                    if let index = receivedMovies.firstIndex(where: { $0.id == movie.id }) {
                        receivedMovies.remove(at: index)
                        
                        if let encodedData = try? JSONEncoder().encode(receivedMovies) {
                            userDefaults.set(encodedData, forKey: "AddedCartMovies")
                            CartManager.shared.loadPurchaseMovies()
                        }
                        
                        viewModel.received.remove(at: indexPath.row)
                        tableView.reloadData()
                    }
                }
            
        }
    }

    
    func makeAlert(titleInput: String , messageInput: String) {
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
        
    }
}
