//
//  CreateGroupsVC.swift
//  WireUp
//
//  Created by Oscar Löfqvist on 23-10-2017.
//  Copyright © 2017 Oscar Löfqvist. All rights reserved.
//

import UIKit
import Firebase

class CreateGroupsVC: UIViewController {
    
    
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var subjectTxtField: UITextField!
    @IBOutlet weak var projectNameTxtField: UITextField!
    @IBOutlet weak var addPeopleTxtField: UITextField!
    @IBOutlet weak var peopleAdded: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var datePicker: UITextField!
    
    let picker = UIDatePicker()
    let currentDate = Date()
    
    var userArray = [String]()
    var chosenUserArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        addPeopleTxtField.delegate = self
        addPeopleTxtField.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
        selectDate()
        closeKeybord()
        
    }
    
    var test = String()
    
    func schoolName(school: String) {
        test = school
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Auth.auth().currentUser?.uid != nil {
            DataService.instance.getSchoolName(forUID: (Auth.auth().currentUser?.uid)!, handler: { (school) in
                self.schoolName(school: school)
            })
        }
        
        doneBtn.isHidden = true
    }
    
    @objc func textFieldDidChanged() {
        if addPeopleTxtField.text == "" {
            userArray = []
            tableView.reloadData()
        } else {
            DataService.instance.getEmail(forSearchQuery: addPeopleTxtField.text!, withSchool: test, handler: { (returnedUserArray) in
                self.userArray = returnedUserArray
                self.tableView.reloadData()
            })
        }
    }
    
    func closeKeybord() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let close = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(closePressed) )
        toolbar.setItems([close], animated: false)
        toolbar.tintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        
        
        addPeopleTxtField.inputAccessoryView = toolbar
        subjectTxtField.inputAccessoryView = toolbar
        projectNameTxtField.inputAccessoryView = toolbar
    }
    
    @objc func closePressed() {
        view.endEditing(true)
    }
    
    func selectDate() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed) )
        toolbar.setItems([done], animated: false)
        toolbar.tintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        
        datePicker.inputAccessoryView = toolbar
        datePicker.inputView = picker
    }
    
    @objc func donePressed() {
        // format date
        
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        let dateString = formatter.string(from: picker.date)
        
        datePicker.text = "\(dateString)"
        
        self.view.endEditing(true)
    }
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        
        let chosenDate = picker.date
        let timeIntervall = chosenDate.timeIntervalSince1970
        let chosenDateInt = Int(timeIntervall)
        
        
        datePicker.text = "\(chosenDateInt)"
        
        let currentTime = currentDate.timeIntervalSince1970
        let intCurrentTime = Int(currentTime)
        
        if subjectTxtField.text != "" && projectNameTxtField.text != "" && datePicker.text != "" {
            DataService.instance.getEmailIds(forUsernames: chosenUserArray, forSchool: test, handler: { (idsArray) in
                var userIds = idsArray
                userIds.append((Auth.auth().currentUser?.uid)!)
                
                DataService.instance.createGroup(withSubject: self.subjectTxtField.text!, andProjectName: self.projectNameTxtField.text!, forEndDate: self.datePicker.text!, forCurrentTime: intCurrentTime, forUserIds: userIds,  handler: { (groupCreated) in
                    if groupCreated {
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        
                    }
                })
            })
        }
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismissCreateGroupVC()
    }
}

extension CreateGroupsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? UserCell else { return UITableViewCell()}
        
        if chosenUserArray.contains(userArray[indexPath.row]) {
            cell.configureCell(userName: userArray[indexPath.row], isSelected: true)
        } else {
            cell.configureCell(userName: userArray[indexPath.row], isSelected: false)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? UserCell else { return }
        if !chosenUserArray.contains(cell.userLbl.text!) {
            chosenUserArray.append(cell.userLbl.text!)
            peopleAdded.text = chosenUserArray.joined(separator: ", ")
            doneBtn.isHidden = false
        } else {
            chosenUserArray = chosenUserArray.filter({ $0 != cell.userLbl.text! })
            if chosenUserArray.count >= 1 {
                peopleAdded.text = chosenUserArray.joined(separator: ", ")
            } else {
                peopleAdded.text = "add people to project"
                doneBtn.isHidden = true
            }
        }
    }
    
}

extension CreateGroupsVC: UITextFieldDelegate {
    
    
    
}















