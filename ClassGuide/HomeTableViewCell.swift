//
//  HomeTableViewCell.swift
//  ClassGuide
//
//  Created by Jesse Chen on 3/22/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var courseCodeLabel: UILabel!
    @IBOutlet weak var courseTitleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
