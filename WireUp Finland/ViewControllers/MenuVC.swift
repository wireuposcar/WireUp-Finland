//
//  MenuVC.swift
//  WireUp
//
//  Created by Oscar Löfqvist on 20-10-2017.
//  Copyright © 2017 Oscar Löfqvist. All rights reserved.
//

import UIKit
import Firebase

class MenuVC: UIViewController {
    
    @IBOutlet weak var groupsTableView: UITableView!
    @IBOutlet weak var welcomeNameLbl: UILabel!
    @IBOutlet weak var infoLbl: UILabel!
    
    var groupsArray = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupsTableView.delegate = self
        groupsTableView.dataSource = self
        
        infoLbl.layer.zPosition = 1
        infoLbl.isHidden = true
        
    }
    
    
    func userName(name: String) {
        self.welcomeNameLbl.text = name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Auth.auth().currentUser?.uid != nil {
            DataService.instance.getUsername(forUID: (Auth.auth().currentUser?.uid)!) { (name) in
                self.userName(name: name)
            }
            
            DataService.instance.REF_GROUPS.observe(.value) { (snapshot) in
                DataService.instance.getAllGroups { (returnedGroupsArray) in
                    self.groupsArray = returnedGroupsArray
                    self.groupsTableView.reloadData()
                }
            }
        } else {
            
        }
    }
    
    @IBAction func settingBtnPressed(_ sender: Any) {
        let toSettingsVC = storyboard?.instantiateViewController(withIdentifier: "settings")
        present(toSettingsVC!, animated: true, completion: nil)
    }
    
    @IBAction func createNewProjcet(_ sender: Any) {
        let toCreateGroupsVC = storyboard?.instantiateViewController(withIdentifier: "createGroups")
        presentCreateGroupVC(toCreateGroupsVC!)
    }
}

extension MenuVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if groupsArray.count < 1 {
            self.infoLbl.isHidden = false
        } else {
            self.infoLbl.isHidden = true
        }
        return groupsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = groupsTableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as? GroupCell else { return UITableViewCell() }
        let group = groupsArray[indexPath.row]
        cell.configureCell(subject: group.subject, projectName: group.projectName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let chatVC = storyboard?.instantiateViewController(withIdentifier: "chat") as? ChatVC else { return }
        chatVC.initData(forGroup: groupsArray[indexPath.row])
        presentDetail(chatVC)
        
    }
    
}










