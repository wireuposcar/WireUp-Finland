//
//  Login.swift
//  WireUp
//
//  Created by Oscar Löfqvist on 18-10-2017.
//  Copyright © 2017 Oscar Löfqvist. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginBtn.layer.cornerRadius = loginBtn.frame.height / 2
        self.hideKeyboard()
    }
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        if emailTxtField.text != nil && passwordTxtField.text != nil {
            AuthService.instance.loginUser(withEmail: emailTxtField.text!, andPassword: passwordTxtField.text!, loginComplete: { (success, loginError) in
                if success {
                    let presentMenuVC = self.storyboard?.instantiateViewController(withIdentifier: "menu")
                    self.present(presentMenuVC!, animated: true, completion: nil)
                } else {
                    let popUpAlert = UIAlertController(title: "Could not login!", message: "Check so you have typed your email and password correctly", preferredStyle: UIAlertControllerStyle.alert)
                    popUpAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(popUpAlert, animated: true, completion: nil)
                }
            })
        }
    }
    
    
}


