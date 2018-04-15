//
//  Task.swift
//  WireUp
//
//  Created by Oscar Löfqvist on 06-11-2017.
//  Copyright © 2017 Oscar Löfqvist. All rights reserved.
//

import Foundation
import Firebase

class Task {
    private var _task: String
    private var _people: String
    private var _senderId: String
    private var _selectedStatus: Bool
    private var _id: String
    
    var id: String {
        return _id
    }
    
    var task: String {
        return _task
    }
    
    var people: String {
        return _people
    }
    
    var senderId: String {
        return _senderId
    }
    
    var selectedStatus: Bool {
        return _selectedStatus
    }
    
    init(task: String, people: String, senderId: String, selectedStatus: Bool, id: String) {
        self._task = task
        self._people = people
        self._senderId = senderId
        self._selectedStatus = selectedStatus
        self._id = id
    }
    
}

