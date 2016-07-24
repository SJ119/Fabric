//
//  recipientTableCell.swift
//  Fabric
//
//  Created by Samantha Lauer on 2016-07-21.
//  Copyright © 2016 Samantha Lauer. All rights reserved.
//

import UIKit

class recipientTableCell: UITableViewCell {

    //MARK Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var NicknameLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
