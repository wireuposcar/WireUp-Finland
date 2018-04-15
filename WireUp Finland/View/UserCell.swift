//
//  UserCell.swift
//  WireUp
//
//  Created by Oscar Löfqvist on 24-10-2017.
//  Copyright © 2017 Oscar Löfqvist. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    @IBOutlet weak var userLbl: UILabel!
    @IBOutlet weak var checkImg: UIImageView!
    
    var showing = false
    
    func configureCell(userName: String, isSelected: Bool) {
        self.userLbl.text = userName
        if isSelected {
            self.checkImg.isHidden = false
        } else {
            self.checkImg.isHidden = true
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            if showing == false {
                checkImg.isHidden = false
                showing = true
            } else {
                checkImg.isHidden = true
                showing = false
            }
        }
        
    }
    
}

