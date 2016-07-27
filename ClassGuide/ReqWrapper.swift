//
//  ReqWrapper.swift
//  ClassGuide
//
//  Created by Jesse Chen on 7/25/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import Foundation

class ReqWrapper {
    let req: Requirement
    var toggled: Bool
    let key: SettingsKey
    
    init(req: Requirement, key: SettingsKey) {
        let defaults = (UIApplication.sharedApplication().delegate as! AppDelegate).defaults
        self.req = req
        self.toggled = defaults.objectForKey(key.rawValue) as? Bool ?? true
        self.key = key
    }
}