//
//  GroupCell.swift
//  WireUp
//
//  Created by Oscar Löfqvist on 25-10-2017.
//  Copyright © 2017 Oscar Löfqvist. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {
    
    @IBOutlet weak var projcetNameLbl: UILabel!
    @IBOutlet weak var subejctLbl: UILabel!
    
    func configureCell(subject: String, projectName: String) {
        self.subejctLbl.text = subject
        self.projcetNameLbl.text = projectName
    }
    
    
}

