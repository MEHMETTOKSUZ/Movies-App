//
//  PurchasedVC.swift
//  MoviesScroll
//
//  Created by Mehmet ÖKSÜZ on 11.05.2023.
//

import UIKit

class PurchasedVC: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var purchsedData = [Results]()
    var rentData = [Results]()
    let purchaseViewModel = PurchasedViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(loadedPurchasedData), name: Notification.Name(rawValue: "PurchasedSucces"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadedRentData), name: Notification.Name(rawValue: "RentSucces"), object: nil)
        loadedPurchasedData()
        loadedRentData()
        collectionView.reloadData()
        segmentController.addTarget(self, action: #selector(segnentControllerClicked(_:)), for: .valueChanged)
      
    }
    
    @IBAction func segnentControllerClicked(_ sender: UISegmentedControl) {
        loadedRentData()
        loadedPurchasedData()
        collectionView.reloadData()
    }
    
    @objc func loadedRentData() {
        
        
        purchaseViewModel.didFinishLoad = { [weak self] in
            self?.collectionView.reloadData()
        }
        purchaseViewModel.loadRentData()
    }
    
    @objc func loadedPurchasedData() {
        
        purchaseViewModel.didFinishLoad = { [weak self] in
            self?.collectionView.reloadData()
        }
        purchaseViewModel.loadPurchaseData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if segmentController.selectedSegmentIndex == 0 {
            return purchaseViewModel.numberOfPurshased
        } else if segmentController.selectedSegmentIndex == 1 {
            return purchaseViewModel.numberOfRent
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "toPurchasedVCFromSettings", for: indexPath) as! PurchasedCell
        
        cell.purchaseReturnButtonOutlet.tag = indexPath.row
        cell.purchaseButtonClicked = {
            let userDefaults = UserDefaults.standard
            
            let purchasedItem = self.purchaseViewModel.getPurchased(at: indexPath.row)
            guard let savedDate = userDefaults.object(forKey: "\(purchasedItem.id)_saved_date") as? Date else {
                return
            }
            
            let minutes = Calendar.current.dateComponents([.minute], from: savedDate, to: Date()).minute ?? 0
            
            let alertController = UIAlertController(title: "Onayla", message: "Silmek istediğinize emin misiniz?", preferredStyle: .alert)
            
            let deleteAction = UIAlertAction(title: "Sil", style: .destructive) { _ in
                if minutes <= 5 {
                    self.purchaseViewModel.purchsedData.remove(at: indexPath.row)
                    userDefaults.set(try? JSONEncoder().encode(self.purchaseViewModel.purchsedData), forKey: "PurchasedMovies")
                    self.collectionView.reloadData()
                    self.makeAlert(titleInput: "Bildirim", messageInput: "İade Edildi")
                } else {
                    self.makeAlert(titleInput: "Bildirim", messageInput: "İade için maksimum süre aşıldı")
                }
            }
            
            let cancelAction = UIAlertAction(title: "Vazgeç", style: .cancel, handler: nil)
            
            alertController.addAction(deleteAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        if segmentController.selectedSegmentIndex == 0 {
            cell.configure(purchased: purchaseViewModel.getPurchased(at: indexPath.row))
        } else if segmentController.selectedSegmentIndex == 1 {
            cell.configure(purchased: purchaseViewModel.getRent(at: indexPath.row))
            if let rentData = UserDefaults.standard.object(forKey: "RentMovies") as? Data {
                let savedData = try? JSONDecoder().decode([Results].self, from: rentData)
                if !savedData!.isEmpty {
                    cell.purchaseReturnButtonOutlet.isHidden = true
                }
            }
        }
        
        cell.purchaseReturnButtonOutlet.isHidden = (segmentController.selectedSegmentIndex == 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.bounds.width
        let cellSize = width / 2 - 15
        return CGSize(width: cellSize, height: cellSize)
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        present(alert, animated: true,completion: nil)
        
    }
}
