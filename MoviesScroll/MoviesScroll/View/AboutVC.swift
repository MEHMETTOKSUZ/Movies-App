//
//  AboutVC.swift
//  MoviesScroll
//
//  Created by Mehmet ÖKSÜZ on 27.03.2023.
//

import UIKit

class AboutVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.frame.size = textView.contentSize
        scrollView.contentSize = textView.contentSize
        scrollView.isScrollEnabled = true
        scrollView.isPagingEnabled = false
        textView.isEditable = false
        
    }
    
}

