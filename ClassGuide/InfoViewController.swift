//
//  InfoViewController.swift
//  ClassGuide
//
//  Created by Jesse Chen on 4/6/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var aboutTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        addRevealVCButton()
        aboutTextView.scrollRangeToVisible(NSMakeRange(0, 0))
    }
    
    override func viewDidAppear(animated: Bool) {
        addPanGesture()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
