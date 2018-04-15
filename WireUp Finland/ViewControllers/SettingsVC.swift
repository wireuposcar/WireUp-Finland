//
//  SettingsVC.swift
//  WireUp
//
//  Created by Oscar Löfqvist on 29-10-2017.
//  Copyright © 2017 Oscar Löfqvist. All rights reserved.
//

import UIKit
import Firebase


class SettingsVC: UIViewController {
    
    var group: Group?
    
    func initData(forGroup group: Group)  {
        self.group = group
    }
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var schoolLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var editName: UIButton!
    @IBOutlet weak var doneEditNameBtn: UIButton!
    @IBOutlet weak var editNameTxtField: UITextField!
    @IBOutlet weak var editNameLine: GradientView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneEditNameBtn.isHidden = true
        editNameTxtField.isHidden = true
        editNameLine.isHidden = true
        self.hideKeyboard()
    }
    
    func userEmail(name: String) {
        self.emailLbl.text = name
    }
    
    func schoolName(school: String) {
        self.schoolLbl.text = school
    }
    
    func username(name: String) {
        self.nameLbl.text = name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Auth.auth().currentUser?.uid != nil {
            DataService.instance.getUserEmail(forUID: (Auth.auth().currentUser?.uid)!, handler: { (email) in
                self.userEmail(name: email)
            })
            DataService.instance.getSchoolName(forUID: (Auth.auth().currentUser?.uid)!, handler: { (school) in
                self.schoolName(school: school)
            })
            DataService.instance.getUsername(forUID: (Auth.auth().currentUser?.uid)!, handler: { (name) in
                self.username(name: name)
            })
        }
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editNameBtnPressed(_ sender: Any) {
        doneEditNameBtn.isHidden = false
        editNameTxtField.isHidden = false
        editNameLine.isHidden = false
        editName.isEnabled = false
    }
    @IBAction func doneBtnPressed(_ sender: Any) {
        if editNameTxtField.text != "" {
            
            let newName = editNameTxtField.text
            
            DataService.instance.changeUsername(forUID: (Auth.auth().currentUser?.uid)!, newName: newName!, sendComplete: { (complete) in
                if complete {
                    self.doneEditNameBtn.isEnabled = true
                    self.doneEditNameBtn.isHidden = true
                    self.editNameTxtField.isHidden = true
                    self.editNameLine.isHidden = true
                    self.editNameTxtField.text = ""
                    self.editName.isEnabled = true
                    self.dismiss(animated: true, completion: nil)
                }
            })
        } else {
            let popUpAlert = UIAlertController(title: "Could not change name", message: "Please make sure you have filled out the text field", preferredStyle: UIAlertControllerStyle.alert)
            popUpAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(popUpAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func supportBtnPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://wireupfinland.com/faq/")! as URL, options: [:], completionHandler: nil)
    }
    
    
    
    @IBAction func logoutBtnPressed(_ sender: Any) {
        let logoutPopup = UIAlertController(title: "Logout?", message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
        
        let logoutAction = UIAlertAction(title: "Logout?", style: .destructive) { (buttonTapped) in
            
            do {
                try Auth.auth().signOut()
                let firstViewVC = self.storyboard?.instantiateViewController(withIdentifier: "firstView") as? FirstViewVC
                self.present(firstViewVC!, animated: true, completion: nil)
                
            } catch {
                print(error)
            }
        }
        
        let logoutActionCancel = UIAlertAction(title: "Cancel", style: .cancel) { (buttonTapped) in
            
        }
        logoutPopup.addAction(logoutAction)
        logoutPopup.addAction(logoutActionCancel)
        present(logoutPopup, animated: true, completion: nil)
    }
}

