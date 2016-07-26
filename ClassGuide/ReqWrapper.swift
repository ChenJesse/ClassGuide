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
    
    init(req: Requirement, toggled: Bool, key: SettingsKey) {
        self.req = req
        self.toggled = toggled
        self.key = key
    }
}