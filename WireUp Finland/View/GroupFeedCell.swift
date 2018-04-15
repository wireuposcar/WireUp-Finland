//
//  GroupFeedCell.swift
//  WireUp
//
//  Created by Oscar Löfqvist on 25-10-2017.
//  Copyright © 2017 Oscar Löfqvist. All rights reserved.
//

import UIKit
import AVFoundation

class GroupFeedCell: UITableViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    
    func configureCell(name: String, content: String) {
        self.nameLbl.text = name //email
        self.contentLbl.text = content
        self.nameLbl.textColor = #colorLiteral(red: 0, green: 0.2886596781, blue: 0.5509795368, alpha: 1)
    }
    
}






