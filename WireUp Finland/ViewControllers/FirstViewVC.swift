//
//  FirstView.swift
//  WireUp
//
//  Created by Oscar Löfqvist on 18-10-2017.
//  Copyright © 2017 Oscar Löfqvist. All rights reserved.
//

import UIKit
import Firebase


class FirstViewVC: UIViewController {
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var createAccountBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginBtn.layer.cornerRadius = loginBtn.frame.height / 2
        createAccountBtn.layer.cornerRadius = createAccountBtn.frame.height / 2
        createAccountBtn.layer.borderWidth = 2
        createAccountBtn.layer.borderColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "login")
        present(loginVC!, animated: true, completion: nil)
    }
    
    @IBAction func createAccountBtnPressed(_ sender: Any) {
        let createAccountVC = storyboard?.instantiateViewController(withIdentifier: "tellMeMore")
        present(createAccountVC!, animated: true, completion: nil)
    }
    
    @IBAction func faqBtnPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://wireupfinland.com/faq/")! as URL, options: [:], completionHandler: nil)
    }
    
    
    
}

