//
//  SettingsTableViewCell.swift
//  ClassGuide
//
//  Created by Jesse Chen on 3/29/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    var delegate: SettingsDelegate!
    
    @IBOutlet weak var toggleSwitch: UISwitch!
    @IBOutlet weak var settingLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func switchToggled(sender: UISwitch) {
        delegate.handleToggle(self)
    }
}
