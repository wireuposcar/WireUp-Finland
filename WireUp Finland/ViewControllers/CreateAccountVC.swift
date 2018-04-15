//
//  CreateAccountVC.swift
//  WireUp
//
//  Created by Oscar Löfqvist on 20-10-2017.
//  Copyright © 2017 Oscar Löfqvist. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountVC: UIViewController {
    
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var createAccountBtn: UIButton!
    
    let ref = Database.database().reference()
    
    var name = String()
    var school = String()
    var schoolCode = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTxtField.delegate = self
        passwordTxtField.delegate = self
        createAccountBtn.layer.cornerRadius = createAccountBtn.frame.height / 2
        self.hideKeyboard()
    }
    
    @IBAction func createAccountBtnPressed(_ sender: Any) {
        if emailTxtField.text != "" && passwordTxtField.text != ""  {
            
            AuthService.instance.registerUser(withEmail: self.emailTxtField.text!, andPassword: self.passwordTxtField.text!, forSchool: self.school, userCreationComplete: { (success, registrationError) in
                if success {
                    AuthService.instance.loginUser(withEmail: self.emailTxtField.text!, andPassword: self.passwordTxtField.text!, loginComplete: { (success, nil) in
                        
                        let user = Auth.auth().currentUser!.uid
                        let firstName = self.name
                        let schoolName = self.school
                        let schoolCode = self.schoolCode
                        
                        let presentMenuVC = self.storyboard?.instantiateViewController(withIdentifier: "menu")
                        self.present(presentMenuVC!, animated: true, completion: nil)
                        self.ref.child("users").child("\(user)").updateChildValues(["firstName": "\(firstName)", "email": self.emailTxtField.text!, "schoolName": "\(schoolName)", "schoolCode": "\(schoolCode)"])
                        
                    })
                } else {
                    let popUpAlert = UIAlertController(title: "Whoops", message: "Check so you have entered an valid email and that your password contains at least 6 characters", preferredStyle: UIAlertControllerStyle.alert)
                    popUpAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(popUpAlert, animated: true, completion: nil)
                }
            })
            
        } else {
            let popUpAlert = UIAlertController(title: "Whoops", message: "Check so you have entered an valid email and that your password contains at least 6 characters", preferredStyle: UIAlertControllerStyle.alert)
            popUpAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(popUpAlert, animated: true, completion: nil)
        }
    }
    
    
    
}

extension CreateAccountVC: UITextFieldDelegate { }




/*
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 let tellMeMore = segue.destination as! TellMeMoreVC
 tellMeMore.name = emailTxtField.text!
 tellMeMore.pass = passwordTxtField.text!
 }
 */
/*
 @IBAction func createAccountBtnPressed(_ sender: Any) {
 if emailTxtField.text != "" && passwordTxtField.text != ""  {
 
 AuthService.instance.registerUser(withEmail: self.emailTxtField.text!, andPassword: self.passwordTxtField.text!, userCreationComplete: { (success, registrationError) in
 if success {
 AuthService.instance.loginUser(withEmail: self.emailTxtField.text!, andPassword: self.passwordTxtField.text!, loginComplete: { (success, nil) in
 
 let toTellMeMore = self.storyboard?.instantiateViewController(withIdentifier: "tellMeMore")
 self.present(toTellMeMore!, animated: true, completion: nil)
 
 })
 } else {
 let popUpAlert = UIAlertController(title: "Whoops", message: "Check so you have entered an valid email and that your password contains at least 6 characters", preferredStyle: UIAlertControllerStyle.alert)
 popUpAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
 self.present(popUpAlert, animated: true, completion: nil)
 }
 })
 
 } else {
 let popUpAlert = UIAlertController(title: "Whoops", message: "Check so you have entered an valid email and that your password contains at least 6 characters", preferredStyle: UIAlertControllerStyle.alert)
 popUpAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
 self.present(popUpAlert, animated: true, completion: nil)
 }
 }
 
 */






