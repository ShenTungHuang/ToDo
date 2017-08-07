//
//  ListNotesTableViewCell.swift
//  ToDo
//
//  Created by STH on 2017/6/23.
//  Copyright © 2017年 STH. All rights reserved.
//

import UIKit

class ListNotesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var noteModificationTimeLabel: UILabel!
    @IBOutlet weak var notecontentlabel: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    
    var tapAction: ((UITableViewCell) -> Void)?
    
    @IBAction func completeList(_ sender: Any) {
        tapAction?(self)
        print("Press Complete button")
    }
    
}
