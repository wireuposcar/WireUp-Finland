//
//  GroupTaskCell.swift
//  WireUp
//
//  Created by Oscar Löfqvist on 08-11-2017.
//  Copyright © 2017 Oscar Löfqvist. All rights reserved.
//

import UIKit
import Firebase

class GroupTaskCell: UITableViewCell {
    
    
    @IBOutlet weak var task: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var chechImg: UIImageView!
    
    var showing = false
    
    func configureTaskCell(taskToDo task: String, nameForPerson name: String, isSelected: Bool ) {
        self.task.text = task
        self.name.text = name
        if isSelected {
            self.chechImg.isHidden = false
        } else {
            self.chechImg.isHidden = true
        }
    }
    
    /* select and deselect check image
     override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            if showing == false {
                chechImg.isHidden = false
                showing = true
            } else {
                chechImg.isHidden = true
                showing = false
            }
        }
     }*/
}

