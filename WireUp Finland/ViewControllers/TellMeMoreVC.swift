//
//  TellMeMoreVC.swift
//  WireUp
//
//  Created by Oscar Löfqvist on 22-10-2017.
//  Copyright © 2017 Oscar Löfqvist. All rights reserved.
//

import UIKit
import Firebase

class TellMeMoreVC: UIViewController {
    
    var schoolsArray = SchoolsArray
    var selectedSchool: String?
    
    let ref = Database.database().reference()
    
    @IBOutlet weak var createAccountBtn: UIButton!
    @IBOutlet weak var firstNameTxtField: UITextField!
    @IBOutlet weak var schoolNameTxtField: UITextField!
    @IBOutlet weak var schoolCodeTxtField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameTxtField.delegate = self
        schoolNameTxtField.delegate = self
        createAccountBtn.layer.cornerRadius = createAccountBtn.frame.height / 2
        self.hideKeyboard()
        
        schoolPicker()
        doneBtn()
    }
    
    func schoolPicker() {
        let schoolPicker = UIPickerView()
        schoolPicker.delegate = self
        
        schoolNameTxtField.inputView = schoolPicker
    }
    
    func doneBtn() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let button = UIBarButtonItem(title: "DONE", style: .plain, target: self, action: #selector(TellMeMoreVC.dismissKeyboard))
        toolbar.setItems([button], animated: false)
        toolbar.isUserInteractionEnabled = true
        schoolNameTxtField.inputAccessoryView = toolbar
    }
    
    override func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func createAccountBtnPressed(_ sender: Any) {
        if firstNameTxtField.text != nil && schoolNameTxtField.text != nil && schoolCodeTxtField.text != nil {
            
            guard let option = schoolNameTxtField.text,
                let index = SchoolsArray.index(where: { $0 == option }),
                CodesArray[index] == schoolCodeTxtField.text
                else {
                    let popUpAlert = UIAlertController(title: "Could not create account!", message: "Please make sure you have filled out all textfields correctly", preferredStyle: UIAlertControllerStyle.alert)
                    popUpAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(popUpAlert, animated: true, completion: nil)
                    return
            }
            self.performSegue(withIdentifier: "toCreateAccountVC", sender: self)
            
        } else {
            
        }
    }
    @IBAction func termsAndConditionsBtnPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://wireupfinland.com/terms-and-conditions")! as URL, options: [:], completionHandler: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let toCreateAccount = segue.destination as! CreateAccountVC
        toCreateAccount.name = firstNameTxtField.text!
        toCreateAccount.school = schoolNameTxtField.text!
        toCreateAccount.schoolCode = schoolCodeTxtField.text!
    }
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}


extension TellMeMoreVC: UITextFieldDelegate { }

extension TellMeMoreVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return schoolsArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return schoolsArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSchool = schoolsArray[row]
        schoolNameTxtField.text = selectedSchool
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = UILabel()
        
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.textAlignment = .center
        label.font = UIFont(name: "Avenier-Next", size: 20)
        label.text = schoolsArray[row]
        return label
    }
    
}

/*
 
 @IBAction func createAccountBtnPressed(_ sender: Any) {
 if firstNameTxtField.text != nil && schoolNameTxtField.text != nil && schoolCodeTxtField.text != nil {
 
 guard let option = schoolNameTxtField.text,
 let index = SchoolsArray.index(where: { $0 == option }),
 CodesArray[index] == schoolCodeTxtField.text
 else {
 let popUpAlert = UIAlertController(title: "Could not create account!", message: "Please make sure you have filled out all textfields", preferredStyle: UIAlertControllerStyle.alert)
 popUpAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
 self.present(popUpAlert, animated: true, completion: nil)
 return
 }
 let user = Auth.auth().currentUser!.uid
 let firstName = self.firstNameTxtField.text
 let schoolName = self.schoolNameTxtField.text
 
 let presentMenuVC = self.storyboard?.instantiateViewController(withIdentifier: "menu")
 self.present(presentMenuVC!, animated: true, completion: nil)
 //self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
 self.ref.child("users").child("\(user)").updateChildValues(["firstName": "\(firstName!)", "schoolName": "\(schoolName!)"])
 
 } else {
 
 }
 }
 
 */















