//
//  Group.swift
//  WireUp
//
//  Created by Oscar Löfqvist on 25-10-2017.
//  Copyright © 2017 Oscar Löfqvist. All rights reserved.
//


import Foundation
import Firebase

class Group {
    private var _subject: String
    private var _projectName: String
    private var _key: String
    private var _member: [String]
    private var _endDate: String
    private var _googleDocs: String
    private var _creationDate: Int
    private var _dropbox: String
    private var _evernote: String
    
    var subject: String {
        return _subject
    }
    var projectName: String {
        return _projectName
    }
    var key: String {
        return _key
    }
    var members: [String] {
        return _member
    }
    
    var endDate: String {
        return _endDate
    }
    
    var creationDate: Int {
        return _creationDate
    }
    
    var googleDocs: String {
        return _googleDocs
    }
    
    var dropbox: String {
        return _dropbox
    }
    
    var evernote: String {
        return _evernote
    }
    
    
    init(subject: String, projectName: String, key: String, members: [String], endDate: String, creationDate: Int, googleDocs: String, dropbox: String, evernote: String) {
        self._subject = subject
        self._projectName = projectName
        self._key = key
        self._member = members
        self._endDate = endDate
        self._googleDocs = googleDocs
        self._creationDate = creationDate
        self._dropbox = dropbox
        self._evernote = evernote
    }
    
}

