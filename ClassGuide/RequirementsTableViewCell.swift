//
//  RequirementsTableViewCell.swift
//  ClassGuide
//
//  Created by Jesse Chen on 3/29/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import UIKit

class RequirementsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var requirementLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var optionalImageView: UIImageView!
    @IBOutlet weak var progressCircle: KDCircularProgress!
    var isCSCourse: Bool!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
