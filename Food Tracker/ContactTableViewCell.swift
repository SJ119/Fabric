//
//  ContactTableViewCell.swift
//  Food Tracker
//
//  Created by Samantha Lauer on 2016-06-23.
//  Copyright © 2016 Samantha Lauer. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    //MARK Properties
    @IBOutlet weak var nameLabel: UIView!
    @IBOutlet weak var contactPhotoView: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
