//
//  EndDateTask .swift
//  WireUp
//
//  Created by Oscar Löfqvist on 24-11-2017.
//  Copyright © 2017 Oscar Löfqvist. All rights reserved.
//

import Foundation
import Firebase

class EndDateTask {
    
    private var _endDate: String
    
    var endDate: String {
        return _endDate
    }
    
    init(endDate: String) {
        self._endDate = endDate
    }
    
    
}

