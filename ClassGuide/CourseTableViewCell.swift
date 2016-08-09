//
//  HomeTableViewCell.swift
//  ClassGuide
//
//  Created by Jesse Chen on 3/22/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import UIKit

class CourseTableViewCell: UITableViewCell {

    @IBOutlet weak var courseCodeLabel: UILabel!
    @IBOutlet weak var courseTitleLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    var course: Course!
    var parentTable: UITableViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .None
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(self.imageTapped))
        statusImageView.userInteractionEnabled = true
        statusImageView.addGestureRecognizer(tapGestureRecognizer)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func imageTapped() {
        switch (course.status) {
        case .None:
            course.status = .PlanTo
        case .PlanTo:
            course.status = .Taken
        case .Taken:
            course.status = .None
        }
        parentTable.tableView.reloadData()
    }
}
