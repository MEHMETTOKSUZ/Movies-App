//
//  SettingsVC.swift
//  MoviesScroll
//
//  Created by Mehmet ÖKSÜZ on 7.02.2023.
//

import UIKit
import Firebase
import FirebaseStorage

class SettingsVC: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var darkModSwitch: UISwitch!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var uploadProfile: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    
    let firestoreDatabase = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        darkModSwitch.addTarget(self, action: #selector(switchClicked(_:)), for: .valueChanged)
        
        profileImage.layer.cornerRadius = 60
        profileImage.layer.masksToBounds = true
        uploadProfile.layer.borderWidth = 2.0
        uploadProfile.layer.borderColor = UIColor.black.cgColor
        uploadProfile.layer.cornerRadius = 15
        uploadProfile.layer.masksToBounds = true
        logOutButton.setTitleColor(UIColor.white, for: .normal)
        logOutButton.contentHorizontalAlignment = .left
        aboutButton.setTitleColor(UIColor.white, for: .normal)
        aboutButton.contentHorizontalAlignment = .left
        usernameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        emailLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        
        getUserInfoFromFirebase()
        getUserImageFromFirebase()
        
    }
    
    @IBAction func switchClicked(_ sender: UISwitch) {
        
        if sender.isOn {
            ThemeHelper.switchToDarkMode()
        } else {
            ThemeHelper.switchToLightMode()
        }
    }
    
    @IBAction func uploadData(_ sender: Any) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            makeAlert(titleInput: "Error", messageInput: "Failed to select image")
            return
        }
        
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child("media")
        let uuid = UUID().uuidString
        
        guard let imageData = selectedImage.jpegData(compressionQuality: 0.5) else {
            makeAlert(titleInput: "Error", messageInput: "Failed to convert image data")
            return
        }
        
        let imageReference = mediaFolder.child("\(uuid).jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        imageReference.putData(imageData, metadata: metadata) { (metadata, error) in
            if let error = error {
                self.makeAlert(titleInput: "Error", messageInput: error.localizedDescription)
            } else {
                imageReference.downloadURL(completion: { (url, error) in
                    if let error = error {
                        self.makeAlert(titleInput: "Error", messageInput: error.localizedDescription)
                    } else {
                        guard let imageUrl = url?.absoluteString else {
                            self.makeAlert(titleInput: "Error", messageInput: "Failed to get image URL")
                            return
                        }
                        
                        let imagesDictionary = ["image": imageUrl,  "imageOwner": Auth.auth().currentUser?.email ?? "" , "timestamp": FieldValue.serverTimestamp()] as [String: Any]
                        let firestore = Firestore.firestore()
                        firestore.collection("Images").addDocument(data: imagesDictionary) { (error) in
                            if let error = error {
                                self.makeAlert(titleInput: "Error", messageInput: error.localizedDescription)
                            } else {
                                self.loadImage(from: imageUrl) { (image) in
                                    DispatchQueue.main.async {
                                        self.profileImage.image = image
                                    }
                                }
                            }
                        }
                    }
                })
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func getUserInfoFromFirebase() {
        
        firestoreDatabase.collection("UserInfo").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { snapshot, error in
            if error != nil {
                self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription  ?? "Error")
                
            } else {
                if snapshot?.isEmpty == false && snapshot != nil {
                    for document in snapshot!.documents {
                        self.emailLabel.text = Auth.auth().currentUser?.email
                        if let username = document.get("userName") as? String {
                            self.usernameLabel.text = username
                            
                        }
                    }
                }
            }
        }
    }
    
    func getUserImageFromFirebase() {
        
        let firestoreImage = Firestore.firestore()
        
        firestoreImage.collection("Images").whereField("imageOwner", isEqualTo: Auth.auth().currentUser!.email!).order(by: "timestamp").getDocuments { snapshot, error in
            if error != nil {
                self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
            } else {
                if snapshot?.isEmpty == false && snapshot != nil {
                    let document = snapshot!.documents.last
                    if let imageString = document?.get("image") as? String {
                        self.loadImage(from: imageString) { [weak self] profileImage in
                            DispatchQueue.main.async {
                                self?.profileImage.image = profileImage
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func logOutClicked(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toSignInVC", sender: nil)
            
        } catch {
            print("error")
        }
    }
    
    func makeAlert(titleInput: String , messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.cancel)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            let image = UIImage(data: data)
            completion(image)
        }
        
        task.resume()
    }
    
    @IBAction func purchasedButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "toPurchasedVCFromSettings", sender: nil)
    }
    
    @IBAction func aboutButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "toAboutVC", sender: nil)
    }
}
