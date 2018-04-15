//
//  DataService.swift
//  WireUp
//
//  Created by Oscar Löfqvist on 18-10-2017.
//  Copyright © 2017 Oscar Löfqvist. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()

class DataService {
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_GROUPS = DB_BASE.child("groups")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_GROUPS: DatabaseReference {
        return _REF_GROUPS
    }
    
    func createDBUser(withSchool: String,uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(withSchool).child(uid).updateChildValues(userData)
    }
    
    //func createDBUser(uid: String, userData: Dictionary<String, Any>) {
    //REF_USERS.child(uid).updateChildValues(userData)
    //}
    
    func getUser(forSearchQuery query: String, handler: @escaping (_ userName: [String]) -> ()) {
        var userArray = [String]()
        REF_USERS.observe(.value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                let firstName = user.childSnapshot(forPath: "firstName").value as? String
                
                if firstName?.contains(query) == true
                {
                    userArray.append(firstName!)
                }
            }
            handler(userArray)
        }
    }
    
    func getIds(forUsernames username: [String], handler: @escaping(_ uidArray: [String]) -> ()) {
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            var idArray = [String]()
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                let firstName = user.childSnapshot(forPath: "firstName").value as? String
                
                if username.contains(firstName!) {
                    idArray.append(user.key)
                }
            }
            handler(idArray)
        }
    }
    
    
    //func for pushing group members to firebase
    func getEmailIds(forUsernames username: [String], forSchool school: String, handler: @escaping(_ uidArray: [String]) -> ()) {
        REF_USERS.child(school).observeSingleEvent(of: .value) { (userSnapshot) in
            var idArray = [String]()
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                let firstName = user.childSnapshot(forPath: "email").value as? String
                
                if username.contains(firstName!) {
                    idArray.append(user.key)
                }
            }
            handler(idArray)
        }
    }
    
    func getSchoolName(forUID uid: String, handler: @escaping (_ schoolName: String) -> ()) {
        REF_USERS.observeSingleEvent(of: .value) { (dataSnapshot) in
            guard let dataSnapshot = dataSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in dataSnapshot {
                if user.key == uid {
                    handler(user.childSnapshot(forPath: "schoolName").value as! String)
                }
            }
        }
    }
    
    func getUserEmail(forUID uid: String, handler: @escaping (_ email: String) -> ()) {
        REF_USERS.observeSingleEvent(of: .value) { (dataSnapshot) in
            guard let dataSnapshot = dataSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in dataSnapshot {
                if user.key == uid {
                    handler(user.childSnapshot(forPath: "email").value as! String)
                }
            }
        }
    }
    
    func getUsername(forUID uid: String, handler: @escaping (_ username: String) -> ()) {
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                if user.key == uid {
                    handler(user.childSnapshot(forPath: "firstName").value as! String)
                }
            }
        }
    }
    
    func getEmail(forSearchQuery query: String, withSchool school: String, handler: @escaping (_ emailArray: [String]) -> ()) {
        var emailArray = [String]()
        REF_USERS.child(school).observe(.value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                let email = user.childSnapshot(forPath: "email").value as! String
                
                if email.contains(query) == true && email != Auth.auth().currentUser?.email {
                    emailArray.append(email)
                }
            }
            handler(emailArray)
        }
    }
    
    func createGroup(withSubject subject: String, andProjectName projectName: String, forEndDate endDate: String, forCurrentTime currenTime: Int,  forUserIds ids: [String], handler: @escaping (_ groupCreated: Bool) -> ()) {
        REF_GROUPS.childByAutoId().updateChildValues(["subject": subject, "projectName": projectName, "endDate": endDate, "members": ids, "creationDate": currenTime, "googleDocs": "", "dropbox": "", "evernote": ""])
        handler(true)
    }
    
    
    func getAllGroups(handler: @escaping (_ groupsArray: [Group]) -> ()) {
        var groupsArray = [Group]()
        REF_GROUPS.observeSingleEvent(of: .value) { (groupSnapshot) in
            guard let groupSnapshot = groupSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for group in groupSnapshot {
                let memberArray = group.childSnapshot(forPath: "members").value as! [String]
                if memberArray.contains((Auth.auth().currentUser?.uid)!) {
                    let projectName = group.childSnapshot(forPath: "projectName").value as! String
                    let subject = group.childSnapshot(forPath: "subject").value as! String
                    let endDate = group.childSnapshot(forPath: "endDate").value as! String
                    let creationDate = group.childSnapshot(forPath: "creationDate").value as! Int
                    let googleDocs = group.childSnapshot(forPath: "googleDocs").value as! String
                    let dropbox = group.childSnapshot(forPath: "dropbox").value as! String
                    let evernote = group.childSnapshot(forPath: "evernote").value as! String
                    let group = Group(subject: subject, projectName: projectName, key: group.key, members: memberArray, endDate: endDate, creationDate: creationDate, googleDocs: googleDocs, dropbox: dropbox, evernote: evernote)
                    groupsArray.append(group)
                }
            }
            handler(groupsArray)
        }
    }
    
    func uploadPost(withMessage message: String, forUID uid: String, withGroupKey groupKey: String?, sendComplete: @escaping (_ status: Bool) -> ()) {
        if groupKey != nil {
            REF_GROUPS.child(groupKey!).child("message").childByAutoId().updateChildValues(["content": message, "senderId": uid])
            sendComplete(true)
        } else {
            
        }
    }
    
    // add task to project
    
    func addTask(withTask task: String, andPeople people: String, forUID uid: String, withGroupKey groupKey: String?, selectedStatus selected: Bool, sendComplete: @escaping (_ taskCreated: Bool ) -> ()) {
        if groupKey != nil {
            REF_GROUPS.child(groupKey!).child("task").childByAutoId().updateChildValues(["taskToDo": task, "peopleToDoTask": people, "senderId": uid, "selected": selected])
            sendComplete(true)
        } else {
            
        }
    }
    
    // add documents to project
    /*
     func addDocs(withUrl url: String, forUID uid: String, withGroupKey groupKey: String?, sendComplete: @escaping (_ added: Bool) -> ()) {
     if groupKey != nil {
     REF_GROUPS.child(groupKey!).child("documents").childByAutoId().updateChildValues(["googleDocs": url, "senderId": uid])
     sendComplete(true)
     } else {
     
     }
     }*/
    
    
    func getAllMessagesForGroup(desiredGroup: Group, handler: @escaping (_ messagesArray: [Message]) -> ()) {
        var groupMessageArray = [Message]()
        REF_GROUPS.child(desiredGroup.key).child("message").observeSingleEvent(of: .value) { (groupMessageSnapshot) in
            guard let groupMessageSnapshot = groupMessageSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for groupMessage in groupMessageSnapshot {
                let content = groupMessage.childSnapshot(forPath: "content").value as! String
                let senderId = groupMessage.childSnapshot(forPath: "senderId").value as! String
                let groupMessage = Message(content: content, senderId: senderId)
                groupMessageArray.append(groupMessage)
            }
            handler(groupMessageArray)
        }
        
    }
    
    func getTasksforGroup(desiredGroup: Group, handler: @escaping (_ taskArray: [Task]) -> ()) {
        var groupTaskArray = [Task]()
        REF_GROUPS.child(desiredGroup.key).child("task").observeSingleEvent(of: .value) { (groupTaskSnapshot) in
            guard let groupTaskSnapshot = groupTaskSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for groupTask in groupTaskSnapshot {
                let task = groupTask.childSnapshot(forPath: "taskToDo").value as! String
                let people = groupTask.childSnapshot(forPath: "peopleToDoTask").value as! String
                let senderId = groupTask.childSnapshot(forPath: "senderId").value as! String
                let selectedStatus = groupTask.childSnapshot(forPath: "selected").value as! Bool
                let groupTask = Task(task: task, people: people, senderId: senderId, selectedStatus: selectedStatus, id: groupTask.key)
                groupTaskArray.append(groupTask)
            }
            handler(groupTaskArray)
        }
    }
    
    func getEndDateForTask(desiredGroup: Group, handler: @escaping (_ endDate: String) -> ()) {
        REF_GROUPS.child(desiredGroup.key).child("task").observeSingleEvent(of: .value) { (endDateSnapshot) in
            guard let endDateSnapshot = endDateSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for endDate in endDateSnapshot {
                handler(endDate.childSnapshot(forPath: "endDate").value as! String)
            }
        }
    }
    
    
    // update gooleDocs
    
    func updateGoogleDocs(withGroupKey groupKey: String?, withUrl url: String?, sendComplete: @escaping (_  added: Bool) -> ()) {
        REF_GROUPS.child(groupKey!).child("googleDocs").setValue(url, andPriority: nil)
        sendComplete(true)
    }
    
    // update DropBox
    
    func updateDropbox(withGroupKey groupKey: String?, withUrl url: String?, sendCoplete: @escaping (_ added: Bool) -> ()) {
        REF_GROUPS.child(groupKey!).child("dropbox").setValue(url, andPriority: nil)
        sendCoplete(true)
    }
    
    // update evernote
    
    func updateEvernote(withGroupKey groupKey: String?, withUrl url: String?, sendCoplete: @escaping (_ added: Bool) -> ()) {
        REF_GROUPS.child(groupKey!).child("evernote").setValue(url, andPriority: nil)
        sendCoplete(true)
    }
    
    // update task status
    
    func updateTaskStatus(desiredGroup: Group, selected: Bool, childPath: String, handler: @escaping (_ taskArray: [Task]) -> ()) {
        
        REF_GROUPS.child(desiredGroup.key).child("task").child(childPath).updateChildValues(["selected": selected])
    }
    
    // update username
    
    func changeUsername(forUID UID: String, newName name: String, sendComplete: @escaping (_ newUsername: Bool) -> ()) {
        REF_USERS.child(UID).updateChildValues(["firstName": name])
        sendComplete(true)
    }
    
    // get emails for group
    
    func getEmailsFor(group: Group, handler: @escaping (_ emailArray: [String]) -> ()) {
        var emailArray = [String]()
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                if group.members.contains(user.key) {
                    let email = user.childSnapshot(forPath: "firstName").value as! String
                    emailArray.append(email)
                }
            }
            handler(emailArray)
        }
    }
    
    
    
    
    
}





















