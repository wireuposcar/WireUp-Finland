//
//  Message.swift
//  WireUp
//
//  Created by Oscar Löfqvist on 27-10-2017.
//  Copyright © 2017 Oscar Löfqvist. All rights reserved.
//

import Foundation
import Firebase

class Message {
    private var _content: String
    private var _senderId: String
    
    var content: String {
        return _content
    }
    
    var senderId: String {
        return _senderId
    }
    
    init(content: String, senderId: String) {
        self._content = content
        self._senderId = senderId
    }
    
}


