//
//  SignInVC.swift
//  MoviesScroll
//
//  Created by Mehmet ÖKSÜZ on 7.02.2023.
//

import UIKit
import Firebase

class SignInVC: UIViewController , UITextFieldDelegate {
    
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordText.isSecureTextEntry = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func logInClicked(_ sender: Any) {
        if emailText.text != "" && passwordText.text != ""  {
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { authdata, error in
                if error != nil {
                    self.makeAlert(titleInput: "Bildirim", messageInput: "Kullanıcı bulunamadı. Kayıt ol butonundan kayıt olabilirsiniz.")
                } else {
                    self.performSegue(withIdentifier: "toMoviesVC", sender: nil)
                }
            }
            
        } else {
            makeAlert(titleInput: "Bildirim", messageInput: "E-Posta ve şifre giriniz.")
        }
    }
    
    @IBAction func signInClicked(_ sender: Any) {
        if emailText.text != "" && passwordText.text != "" &&  usernameText.text != "" {
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { authdata, error in
                if error != nil {
                    self.makeAlert(titleInput: "Bildirim", messageInput: error?.localizedDescription ?? "Bildirim")
                    
                } else {
                    
                    let firebase = Firestore.firestore()
                    let userDictionary = [ "email" : self.emailText.text! , "userName": self.usernameText.text!] as [String : Any]
                    firebase.collection("UserInfo").addDocument(data: userDictionary) { error in
                        if error != nil {
                            
                        }
                    }
                    self.performSegue(withIdentifier: "toMoviesVC", sender: nil)
                }
            }
            
        } else {
            makeAlert(titleInput: "Bildirim", messageInput: "Lütfen zorunlu alanları doldurun.")
        }
    }
    
    func makeAlert(titleInput: String , messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "KAPAT", style: UIAlertAction.Style.cancel)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
    }
}
