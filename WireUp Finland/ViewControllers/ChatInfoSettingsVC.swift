//
//  ChatInfoSettingsVC.swift
//  WireUp
//
//  Created by Oscar Löfqvist on 06-11-2017.
//  Copyright © 2017 Oscar Löfqvist. All rights reserved.
//

import UIKit
import Firebase

class ChatInfoSettingsVC: UIViewController {
    
    var group: Group?
    
    func initData(forGroup group: Group)  {
        self.group = group
    }
    
    @IBOutlet weak var addTaskTxtField: UITextField!
    @IBOutlet weak var peopleTxtField: UITextField!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var googleDocsTxtField: UITextField!
    @IBOutlet weak var googleDocsBtn: UIButton!
    @IBOutlet weak var dropboxTxtField: UITextField!
    @IBOutlet weak var dropboxBtn: UIButton!
    @IBOutlet weak var evernoteTxtField: UITextField!
    @IBOutlet weak var evernoteBtn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismissDetail()
    }
    
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        if self.addTaskTxtField.text != "" && self.peopleTxtField.text != ""  {
            addTaskTxtField.isEnabled = false
            peopleTxtField.isEnabled = false
            doneBtn.isEnabled = false
            
            DataService.instance.addTask(withTask: self.addTaskTxtField.text!, andPeople: self.peopleTxtField.text!, forUID: Auth.auth().currentUser!.uid, withGroupKey: group?.key, selectedStatus: false, sendComplete: { (complete) in
                if complete {
                    self.addTaskTxtField.text = ""
                    self.peopleTxtField.text = ""
                    self.addTaskTxtField.isEnabled = true
                    self.peopleTxtField.isEnabled = true
                    self.doneBtn.isEnabled = true
                }
            })
        } else {
            let popUpAlert = UIAlertController(title: "Could not create task", message: "Please make sure you have filled out both text fields", preferredStyle: UIAlertControllerStyle.alert)
            popUpAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(popUpAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func googleDocsBtnPressed(_ sender: Any) {
        if self.googleDocsTxtField.text != "" {
            googleDocsTxtField.isEnabled = false
            googleDocsBtn.isEnabled = false
            
            DataService.instance.updateGoogleDocs(withGroupKey: group?.key, withUrl: self.googleDocsTxtField.text!, sendComplete: { (complete) in
                if complete {
                    self.googleDocsTxtField.text = ""
                    self.googleDocsBtn.isEnabled = true
                    self.googleDocsTxtField.isEnabled = true
                }
            })
        }
    }
    
    @IBAction func dropboxBtnPressed(_ sender: Any) {
        if self.dropboxTxtField.text != "" {
            dropboxTxtField.isEnabled = false
            dropboxBtn.isEnabled = false
            
            DataService.instance.updateDropbox(withGroupKey: group?.key, withUrl: self.dropboxTxtField.text!, sendCoplete: { (complete) in
                if complete {
                    self.dropboxTxtField.text = ""
                    self.dropboxBtn.isEnabled = true
                    self.dropboxTxtField.isEnabled = true
                }
            })
        }
    }
    
    @IBAction func evernoteBtnPressed(_ sender: Any) {
        if self.evernoteTxtField.text != "" {
            evernoteTxtField.isEnabled = false
            evernoteBtn.isEnabled = false
            
            DataService.instance.updateDropbox(withGroupKey: group?.key, withUrl: self.evernoteTxtField.text!, sendCoplete: { (complete) in
                if complete {
                    self.evernoteTxtField.text = ""
                    self.evernoteBtn.isEnabled = true
                    self.evernoteTxtField.isEnabled = true
                }
                
            })
        }
    }
    
    
    
}



