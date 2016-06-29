//
//  DoneTableViewCell.swift
//  Food Tracker
//
//  Created by Shen Jin on 2016-06-26.
//  Copyright © 2016 Samantha Lauer. All rights reserved.
//

import UIKit

class DoneTableViewCell: TaskTableViewCell {

    @IBOutlet weak var nameLabel2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
