//
//  RevealExtension.swift
//  ClassGuide
//
//  Created by Jesse Chen on 3/24/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import Foundation

extension UIViewController {
    
    func addRevealVCButton() {
        let image = UIImage(named: "hamburgerIcon")!
        let menuButton = UIButton(frame: CGRect(origin: CGPointZero, size: image.size))
        menuButton.setImage(image, forState: .Normal)
        menuButton.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), forControlEvents: .TouchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
    }
    
    func addPanGesture() {
        self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
    }
    
}