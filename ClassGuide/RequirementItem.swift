//
//  RequirementItem.swift
//  ClassGuide
//
//  Created by Jesse Chen on 4/16/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import Foundation

class RequirementItem {
    
    var description: String
    var percentage: Float
    var priority: Priority
    
    internal init(description: String, percentage: Float, type: Priority) {
        self.description = description
        self.percentage = percentage
        self.priority = type
    }
    
}