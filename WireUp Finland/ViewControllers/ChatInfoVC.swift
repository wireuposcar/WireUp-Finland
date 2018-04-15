//
//  ChatInfoVC.swift
//  WireUp
//
//  Created by Oscar Löfqvist on 29-10-2017.
//  Copyright © 2017 Oscar Löfqvist. All rights reserved.
//

import UIKit
import Firebase

class ChatInfoVC: UIViewController {
    
    var group: Group?
    var groupTask = [Task]()
    var endDate = [EndDateTask]()
    var googleDocsUrl = String()
    var dropboxUrl = String()
    var evernoteUrl = String()
    
    let currentDate = Date()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var daysLeft: UILabel!
    @IBOutlet weak var memberNames: UILabel!
    @IBOutlet weak var groupIcon: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var infoLbl: UILabel!
    
    func initData(forGroup group: Group)  {
        self.group = group
    }
    
    @IBAction func googleDocsPressed(_ sender: Any) {
        
        if googleDocsUrl != "" {
            UIApplication.shared.open(URL(string: googleDocsUrl)! as URL, options: [:], completionHandler: nil)
        } else {
            return
        }
    }
    
    @IBAction func dropBoxPressed(_ sender: Any) {
        
        if dropboxUrl != "" {
            UIApplication.shared.open(URL(string: dropboxUrl)! as URL, options: [:], completionHandler: nil)
        } else {
            return
        }
    }
    
    @IBAction func evernotePressed(_ sender: Any) {
        if evernoteUrl != "" {
            UIApplication.shared.open(URL(string: evernoteUrl)! as URL, options: [:], completionHandler: nil)
        } else {
            return
        }
    }
    
    
    @objc func updateProgressBar() {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let endDate = group?.endDate
        let creationDate = group?.creationDate
        
        // current time
        let currentTime = currentDate.timeIntervalSince1970
        let intCurrentTime = Int(currentTime)
        
        // end time
        let intEndTime: Int = Int(endDate!)!
        let intCurrentTimeShorted = Float(intCurrentTime) / 1000
        let creationDateShorted = Float(creationDate!) / 1000
        let intEndTimeShorted = Float(intEndTime) / 1000
        
        let numerator = intCurrentTimeShorted - creationDateShorted
        let denominator = intEndTimeShorted - creationDateShorted
        
        let difference = numerator / denominator
        
        if difference >= 0.8 {
            progressBar.tintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        }
        if difference >= 0.95 {
            progressBar.tintColor = #colorLiteral(red: 0.9529411765, green: 0, blue: 0, alpha: 1)
        }
        
        googleDocsUrl = (group?.googleDocs)!
        dropboxUrl = (group?.dropbox)!
        evernoteUrl = (group?.evernote)!
        
        // progress
        tableView.delegate = self
        tableView.dataSource = self
        progressBar.setProgress(difference, animated: true)
        
        infoLbl.layer.zPosition = 100
        infoLbl.isHidden = true
        
        // swipe
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeActionLeft(swipe:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    // swipe
    
    @objc func swipeActionLeft(swipe: UISwipeGestureRecognizer) {
        switch swipe.direction.rawValue {
        case 2:
            guard let toChatInfo = storyboard?.instantiateViewController(withIdentifier: "chatInfoSettings") as? ChatInfoSettingsVC else { return }
            toChatInfo.initData(forGroup: group!)
            presentDetail(toChatInfo)
        default:
            break
        }
    }
    
    func googleDocs(link: String) {
        googleDocsUrl = link
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let endDateShow = group?.endDate
        let endDateIntShow: Int = Int(endDateShow!)!
        let endDateAsDate = Date(timeIntervalSince1970: TimeInterval(endDateIntShow))
        
        let DateFormat : DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy hh:mm"
            return formatter
        }()
        
        let dateFormattedToShow = DateFormat.string(from: endDateAsDate)
        
        daysLeft.text = dateFormattedToShow
        
        groupIcon.text = group?.projectName
        
        
        DataService.instance.getEmailsFor(group: self.group!) { (returnedEmails) in
            self.memberNames.text = returnedEmails.joined(separator: ", ")
        }
        
        DataService.instance.REF_GROUPS.observe(.value) { (snapShot) in
            DataService.instance.getTasksforGroup(desiredGroup: self.group!, handler: { (returnedGroupTask) in
                self.groupTask = returnedGroupTask
                self.tableView.reloadData()
                
                if self.groupTask.count > 0 {
                    self.tableView.scrollToRow(at: IndexPath.init(row: self.groupTask.count - 1, section: 0), at: .none, animated: true)
                }
            })
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        dismissDetail()
    }
    @IBAction func toChatInfoSettings(_ sender: Any) {
        guard let toChatInfoSetting = storyboard?.instantiateViewController(withIdentifier: "chatInfoSettings") as? ChatInfoSettingsVC else { return }
        toChatInfoSetting.initData(forGroup: group!)
        presentDetail(toChatInfoSetting)
    }
}

extension ChatInfoVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if groupTask.count < 1 {
            self.infoLbl.isHidden = false
        } else {
            self.infoLbl.isHidden = true
        }
        return groupTask.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "thingstodoCell", for: indexPath) as? GroupTaskCell else { return UITableViewCell()}
        
        
        let task = groupTask[indexPath.row]
        let selected = groupTask[indexPath.row]
        cell.configureTaskCell(taskToDo: task.task, nameForPerson: task.people, isSelected: selected.selectedStatus)
        
        return cell
    }
    
    // remove task
    /*
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     
     let taskToDelete = groupTask[indexPath.row]
     //tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
     if editingStyle == UITableViewCellEditingStyle.delete {
     groupTask.remove(at: indexPath.row)
     DataService.instance.REF_GROUPS.child(group!.key).child("task").child(taskToDelete.id).removeValue(completionBlock: { (error, refer) in
     if error != nil {
     
     } else {
     
     }
     })
     //self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
     }
     }*/
    
    // update task value
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? GroupTaskCell else { return }
        
        if cell.isSelected == true {
            let selected = groupTask[indexPath.row]
            DataService.instance.REF_GROUPS.observe(.value) { (snapShot) in
                DataService.instance.updateTaskStatus(desiredGroup: self.group!, selected: true, childPath: selected.id, handler: { (complete) in
                    self.tableView.reloadData()
                })
            }
        } else {
            
        }
        self.tableView.reloadData()
    }
}




