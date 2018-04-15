//
//  ChatVC.swift
//  WireUp
//
//  Created by Oscar Löfqvist on 20-10-2017.
//  Copyright © 2017 Oscar Löfqvist. All rights reserved.
//

import UIKit
import Firebase

class ChatVC: UIViewController  {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var projectNameLbl: UILabel!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var messageTxtField: UITextField!
    @IBOutlet weak var sendBtnView: UIView!
    @IBOutlet weak var sendAndTxtFieldView: UIView!
    @IBOutlet var mainView: UIView!
    
    
    var group: Group?
    var groupMessages = [Message]()
    
    func initData(forGroup group: Group)  {
        self.group = group
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.bindToKeyboard()
        //sendAndTxtFieldView.bindToKeyboard()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 66
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.reloadData()
        
        self.hideKeyboard()
        
        
        
        // swipe
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeActionLeft(swipe:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    // swipe
    
    @objc func swipeActionLeft(swipe: UISwipeGestureRecognizer) {
        switch swipe.direction.rawValue {
        case 2:
            guard let toChatInfo = storyboard?.instantiateViewController(withIdentifier: "chatInfo") as? ChatInfoVC else { return }
            toChatInfo.initData(forGroup: group!)
            presentDetail(toChatInfo)
        default:
            break
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.layoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction func menuBtnPressed(_ sender: Any) {
        dismissDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        projectNameLbl.text = group?.projectName
        DataService.instance.REF_GROUPS.observe(.value) { (snapshot) in
            DataService.instance.getAllMessagesForGroup(desiredGroup: self.group!, handler: { (returnedGroupMessages) in
                self.groupMessages = returnedGroupMessages
                self.tableView.reloadData()
                
                if self.groupMessages.count > 0 {
                    self.tableView.scrollToRow(at: IndexPath.init(row: self.groupMessages.count - 1, section: 0), at: .none, animated: true)
                }
            })
        }
    }
    
    @IBAction func toChatInfo(_ sender: Any) {
        guard let toChatInfo = storyboard?.instantiateViewController(withIdentifier: "chatInfo") as? ChatInfoVC else { return }
        toChatInfo.initData(forGroup: group!)
        presentDetail(toChatInfo)
    }
    @IBAction func sendBtnPressed(_ sender: Any) {
        if messageTxtField.text != "" {
            messageTxtField.isEnabled = false
            sendBtn.isEnabled = false
            DataService.instance.uploadPost(withMessage: messageTxtField.text!, forUID: Auth.auth().currentUser!.uid, withGroupKey: group?.key, sendComplete: { (complete) in
                if complete {
                    self.messageTxtField.text = ""
                    self.messageTxtField.isEnabled = true
                    self.sendBtn.isEnabled = true
                }
            })
        }
    }
}

extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupFeedCell", for: indexPath) as? GroupFeedCell else { return UITableViewCell() }
        
        let message = groupMessages[indexPath.row]
        
        DataService.instance.getUsername(forUID: message.senderId, handler: { (name) in
            cell.configureCell(name: name, content: message.content)
        })
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        cell.layoutSubviews()
        cell.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
}

extension UIViewController {
    
}


























