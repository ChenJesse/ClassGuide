//
//  AboutHeaderView.swift
//  ClassGuide
//
//  Created by Jesse Chen on 5/16/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import UIKit

class AboutHeaderView: UICollectionReusableView {

    @IBOutlet weak var majorButton: UIButton!
    let majorURL = NSURL(string: "https://www.cs.cornell.edu/undergrad/csmajor")
    @IBAction func majorButtonClicked(sender: UIButton) {
        UIApplication.sharedApplication().openURL(majorURL!)
    }
}
