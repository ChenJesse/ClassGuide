//
//  StyleExtension.swift
//  ClassGuide
//
//  Created by Jesse Chen on 3/24/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import Foundation

extension UIColor {
    @nonobjc static let cornellRed = UIColor(red: 156.0/255.0, green: 50.0/255.0, blue: 44.0/255.0, alpha: 1.0)
    @nonobjc static let darkGrey = UIColor(red: 26.0/255.0, green: 26.0/255.0, blue: 26.0/255.0, alpha: 1.0)
    @nonobjc static let darkGreen = UIColor(red: 0.0/255.0, green: 153.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    @nonobjc static let maroon = UIColor(red: 102.0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
}

extension UIView {
    func addDropShadowToView(targetView: UIView?) {
        targetView!.layer.masksToBounds =  false
        targetView!.layer.shadowColor = UIColor.blackColor().CGColor;
        targetView!.layer.shadowOffset = CGSizeMake(0.1, 0.1)
        targetView!.layer.shadowOpacity = 1.0
    }
}

extension UIViewController {
    public func normalizeNavBar() {
        navigationController?.navigationBarHidden = false
        navigationController?.hidesBarsOnSwipe = false
    }
}