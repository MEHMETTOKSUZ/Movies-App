//
//  PaymentVC.swift
//  MoviesScroll
//
//  Created by Mehmet ÖKSÜZ on 2.04.2023.
//

import UIKit

class PaymentVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var nameSurnameText: UITextField!
    @IBOutlet weak var nameAlertText: UILabel!
    @IBOutlet weak var phoneNumberText: UITextField!
    @IBOutlet weak var phoneNumberAlertText: UILabel!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var emailAlertText: UILabel!
    @IBOutlet weak var identifierNumberText: UITextField!
    @IBOutlet weak var identificationAlertText: UILabel!
    @IBOutlet weak var cardNameText: UITextField!
    @IBOutlet weak var cardNameAlertText: UILabel!
    @IBOutlet weak var cardNumberText: UITextField!
    @IBOutlet weak var cardNumberAlertText: UILabel!
    @IBOutlet weak var cardMonthText: UITextField!
    @IBOutlet weak var cardYearText: UITextField!
    @IBOutlet weak var cardCVVText: UITextField!
    @IBOutlet weak var checkmarkSqure: UIButton!
    @IBOutlet weak var ConfirmPayment: UIButton!
    @IBOutlet weak var checkmarkAlertText: UILabel!
    @IBOutlet weak var cardMonthAlertText: UILabel!
    @IBOutlet weak var cardYearAlertText: UILabel!
    @IBOutlet weak var cardCVVAlertText: UILabel!
    @IBOutlet weak var checkmarkSqureButton: UIButton!
    @IBOutlet weak var totalPurchasePriceLabel: UILabel!
    @IBOutlet weak var totalRentPriceLabel: UILabel!
    @IBOutlet weak var userAgrements: UITextView!
    
    var savedMovies = [Results]()
    var receivedMovies = [Results]()
    let years = Array(2023...2045)
    let months = ["Ocak", "Şubat", "Mart", "Nisan", "Mayıs", "Haziran", "Temmuz", "Ağustos", "Eylül", "Ekim", "Kasım", "Aralık"]
    let resultsLabel = UILabel(frame: CGRect(x: 20, y: 200, width: 200, height: 200))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userAgrements.isHidden = true
        let pickerViewMonth = UIPickerView()
        pickerViewMonth.delegate = self
        pickerViewMonth.dataSource = self
        cardMonthText.inputView = pickerViewMonth
        
        let pickerViewYear = UIPickerView()
        pickerViewYear.delegate = self
        pickerViewYear.dataSource = self
        cardYearText.inputView = pickerViewYear
        
       
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
        hideAlertLabels()
        loadedreceivedMovies()
        CartManager.shared.loadPurchaseMovies()
        
        identifierNumberText.delegate = self
        nameSurnameText.delegate = self
        phoneNumberText.delegate = self
        cardNameText.delegate = self
        cardCVVText.delegate = self
        emailText.delegate = self
        
        cardNumberText.addTarget(self, action: #selector(formatCardNumber), for: .editingChanged)
        phoneNumberText.addTarget(self, action: #selector(formatPhoneNumber(_:)), for: .editingChanged)
        emailText.addTarget(self, action: #selector(formatEmail), for: .editingChanged)
        cardCVVText.addTarget(self, action: #selector(formatCVVNumber), for: .editingChanged)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadedreceivedMovies), name: NSNotification.Name(rawValue: "newDataAdded"), object: nil)
        
        if let addedCartMoviesData = UserDefaults.standard.value(forKey: "AddedCartMovies") as? Data {
            let decoder = JSONDecoder()
            if let addedCartMovies = try? decoder.decode([Results].self, from: addedCartMoviesData) {
                let totalPrice = Double(addedCartMovies.count) * 2.99
                let formattedPrice = String(format: "%.2f", totalPrice)
                totalPurchasePriceLabel.text = "Total Price: $\(formattedPrice)"
                let totalRentPrice = Double(addedCartMovies.count) * 0.99
                let formatRentPrice = String(format: "%.2f", totalRentPrice)
                totalRentPriceLabel.text = "Total Price: $\(formatRentPrice)"
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == nameSurnameText || textField == cardNameText {
            let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
            let isTextFieldEmpty = updatedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            if textField == nameSurnameText {
                nameAlertText.isHidden = !isTextFieldEmpty
            } else if textField == cardNameText {
                cardNameAlertText.isHidden = !isTextFieldEmpty
            }
        } else if textField == identifierNumberText {
            let currentText = textField.text ?? ""
            guard let range = Range(range, in: currentText) else {
                return false
            }
            
            let updatedText = currentText.replacingCharacters(in: range, with: string)
            
            guard CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) else {
                return false
            }
            
            let maxLength = 11
            if updatedText.count > maxLength {
                return false
            }
            
            identificationAlertText.isHidden = !updatedText.isEmpty
        }
        
        return true
        
    }
    
    @objc func loadedreceivedMovies() {
        
        loadreceivedMovies { data in
            self.receivedMovies = data
            
        }
    }
    
    func loadreceivedMovies(completion : ([Results]) -> ()){
        if let receivedMovies = UserDefaults.standard.object(forKey: "AddedCartMovies") as? Data {
            let savedItems = try? JSONDecoder().decode([Results].self, from: receivedMovies)
            completion(savedItems!)
            
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == cardMonthText.inputView {
            return months.count
        } else {
            return years.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == cardMonthText.inputView {
            return months[row]
        } else {
            return String(years[row])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == cardMonthText.inputView {
            let selectedMonth = months[row]
            cardMonthText.text = selectedMonth
            cardMonthAlertText.isHidden = true
        } else {
            let selectedYear = years[row]
            cardYearText.text = String(selectedYear)
            cardYearAlertText.isHidden = true
        }
        
        let monthText = cardMonthText.text ?? ""
        let yearText = cardYearText.text ?? ""
        
        resultsLabel.text = "\(monthText) \(yearText)"
    }
    
    @IBAction func checkmarkSqureButtonClicked(_ sender: UIButton) {
        
        sender.isSelected.toggle()
        if sender.isSelected {
            sender.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            checkmarkAlertText.isHidden = true
        } else {
            sender.setImage(UIImage(systemName: "square"), for: .normal)
            checkmarkAlertText.isHidden = false
        }
    }
    
    @IBAction func ConfirmPaymentButtonClicked(_ sender: UIButton) {
        
        checkLabelsEmpty()
        
        if  nameSurnameText.text != "" && phoneNumberText.text != "" && emailText.text != "" && identifierNumberText.text != "" && cardNameText.text != "" && cardNumberText.text != "" && cardMonthText.text != "" && cardYearText.text != "" && cardCVVText.text != "" {
            if checkmarkSqureButton.isSelected {
                saveUserdefaultsPurchased()
                makeAlert(titleInput: "Bildirim", messageInput: "Satın Alma Başarılı!")
                
            } else {
                checkmarkAlertText.isHidden = false
            }
        }
    }
    
    @IBAction func rentMoviesButtonClicked(_ sender: Any) {
        
        checkLabelsEmpty()
        
        if  nameSurnameText.text != "" && phoneNumberText.text != "" && emailText.text != "" && identifierNumberText.text != "" && cardNameText.text != "" && cardNumberText.text != "" && cardMonthText.text != "" && cardYearText.text != "" && cardCVVText.text != "" {
            if checkmarkSqureButton.isSelected {
                saveUserdefaultsRent()
                makeAlert(titleInput: "Bildirim", messageInput: "Kiralama Başarılı!")
                
            } else {
                checkmarkAlertText.isHidden = false
            }
        }
    }
    
    func saveUserdefaultsPurchased() {
        
        let userDefaults = UserDefaults.standard
        
        
        if let data = userDefaults.object(forKey: "PurchasedMovies") as? Data {
            if let loadedPurchaseMovies = try? JSONDecoder().decode([Results].self, from: data) {
                savedMovies = loadedPurchaseMovies
            }
        }
        
        for purchasedMovies in receivedMovies {
            if savedMovies.contains(where: { $0.id == purchasedMovies.id }) {
                print("Bu ID'ye sahip bir film zaten kaydedildi: \(purchasedMovies.original_title)")
            } else {
                savedMovies.append(purchasedMovies)
                userDefaults.set(Date(), forKey: "\(purchasedMovies.id)_saved_date")
            }
        }
        
        userDefaults.set(try? JSONEncoder().encode(savedMovies), forKey: "PurchasedMovies")
        userDefaults.removeObject(forKey: "AddedCartMovies")
        NotificationCenter.default.post(name: NSNotification.Name("PurchasedSucces"), object: nil)
        CartManager.shared.clearPurchaseMovies()
    }
    
    func saveUserdefaultsRent() {
        let userDefaults = UserDefaults.standard
        
        var savedMovies = [Results]()
        if let data = userDefaults.object(forKey: "RentMovies") as? Data,
           let loadedRentMovies = try? JSONDecoder().decode([Results].self, from: data) {
            savedMovies = loadedRentMovies
        }
        
        for rentedMovies in receivedMovies {
            if savedMovies.contains(where: { $0.id == rentedMovies.id }) {
                print("Bu ID'ye sahip bir film zaten kaydedildi: \(rentedMovies.original_title)")
            } else {
                savedMovies.append(rentedMovies)
                userDefaults.set(Date(), forKey: "\(rentedMovies.id)_rental_date")
            }
        }
        
        userDefaults.set(try? JSONEncoder().encode(savedMovies), forKey: "RentMovies")
        userDefaults.synchronize()
        
        NotificationCenter.default.post(name: NSNotification.Name("RentSucces"), object: nil)
        
        let timer = Timer.scheduledTimer(withTimeInterval: 20.0, repeats: false) { timer in
            for movie in savedMovies {
                userDefaults.removeObject(forKey: "\(movie.id)_rental_date")
            }
            userDefaults.removeObject(forKey: "RentMovies")
        }
        RunLoop.main.add(timer, forMode: .common)
        
        userDefaults.removeObject(forKey: "AddedCartMovies")
        CartManager.shared.clearPurchaseMovies()
    }
    
    @objc func formatPhoneNumber(_ textField: UITextField) {
        if let text = textField.text {
            var formattedText = ""
            let numbers = text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            let mask = "XXX XXX XX XX"
            
            var index = numbers.startIndex
            for ch in mask where index < numbers.endIndex {
                if ch == "X" {
                    formattedText.append(numbers[index])
                    index = numbers.index(after: index)
                } else {
                    formattedText.append(ch)
                }
            }
            
            textField.text = formattedText
            
            if text.isEmpty {
                phoneNumberAlertText.isHidden = false
            } else {
                phoneNumberAlertText.isHidden = true
            }
        }
    }
    
    
    @objc func formatCardNumber(_ textField: UITextField) {
        if let text = textField.text {
            var formattedText = ""
            let numbers = text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            let mask = "XXXX XXXX XXXX XXXX"
            
            var index = numbers.startIndex
            for ch in mask where index < numbers.endIndex {
                if ch == "X" {
                    formattedText.append(numbers[index])
                    index = numbers.index(after: index)
                } else {
                    formattedText.append(ch)
                }
            }
            
            textField.text = formattedText
            
            if text.isEmpty {
                cardNumberAlertText.isHidden = false
            } else {
                cardNumberAlertText.isHidden = true
            }
        }
    }
    
    @objc func formatCVVNumber(_ textField: UITextField) {
        if let text = textField.text {
            var formattedText = ""
            let numbers = text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            let mask = "XXX"
            
            var index = numbers.startIndex
            for ch in mask where index < numbers.endIndex {
                if ch == "X" {
                    formattedText.append(numbers[index])
                    index = numbers.index(after: index)
                } else {
                    formattedText.append(ch)
                }
            }
            
            textField.text = formattedText
            
            if text.isEmpty {
                cardCVVAlertText.isHidden = false
            } else {
                cardCVVAlertText.isHidden = true
            }
        }
    }
    
    @objc func formatEmail() {
        
        let emailPattern = #"(?:[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?\.)+[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[A-Za-z0-9-]*[A-Za-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])"#
        
        if let email = emailText.text, !email.isEmpty {
            let predicate = NSPredicate(format:"SELF MATCHES %@", emailPattern)
            if !predicate.evaluate(with: email) {
                emailAlertText.isHidden = false
                emailAlertText.text = "Geçersiz email adresi"
                return
            } else {
                emailAlertText.isHidden = true
            }
        }
    }
    
    func checkLabelsEmpty() {
        
        nameAlertText.isHidden = !nameSurnameText.text!.isEmpty
        phoneNumberAlertText.isHidden = !phoneNumberText.text!.isEmpty
        emailAlertText.isHidden = !emailText.text!.isEmpty
        identificationAlertText.isHidden = !identifierNumberText.text!.isEmpty
        cardNameAlertText.isHidden = !cardNameText.text!.isEmpty
        cardNumberAlertText.isHidden = !cardNumberText.text!.isEmpty
        cardMonthAlertText.isHidden = !cardMonthText.text!.isEmpty
        cardYearAlertText.isHidden = !cardYearText.text!.isEmpty
        cardCVVAlertText.isHidden = !cardCVVText.text!.isEmpty
        
    }
    
    func hideAlertLabels() {
        nameAlertText.isHidden = true
        phoneNumberAlertText.isHidden = true
        emailAlertText.isHidden = true
        identificationAlertText.isHidden = true
        cardNameAlertText.isHidden = true
        cardNumberAlertText.isHidden = true
        cardMonthAlertText.isHidden = true
        cardYearAlertText.isHidden = true
        cardCVVAlertText.isHidden = true
        checkmarkAlertText.isHidden = true
        
    }
    
    @IBAction func userAgreementButton(_ sender: Any) {
        
        userAgrements.isHidden = false
        
    }
    
    func makeAlert(titleInput: String , messageInput: String) {
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Taman", style: .default) { (action) in
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
            
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}



