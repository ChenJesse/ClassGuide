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
    var expanded = false
    var section: Int?
    var container: UIView?
    
    @IBOutlet weak var toggleSwitch: UISwitch!
    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func switchToggled(sender: UISwitch) {
        delegate.handleToggle(self)
    }
    
    func rotateArrow() {
        if !expanded {
            arrowImageView.transform = CGAffineTransformMakeRotation((180.0 * CGFloat(M_PI)) / 180.0)
        } else {
            arrowImageView.transform = CGAffineTransformMakeRotation(0)
        }
        expanded = !expanded
            
    }
}
