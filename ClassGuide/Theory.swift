//
//  Theory.swift
//  ClassGuide
//
//  Created by Jesse Chen on 8/15/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import Foundation

class Theory: ReqSet {
    static let sharedInstance = Theory() as ReqSet
    let title = "Theory"
    let key = SettingsKey.Theory
    
    var taken481x = RequirementItem(fulfillment: 1, description: "CS481x (Core) ", type: .Mandatory, supported: .Supported)
    var reqItems: [RequirementItem]!
    
    init() {
        reqItems = [
            taken481x,
            RequirementItem(fulfillment: 1, description: "2(CSF8xx/ORIE6330/ORIE6335) (Core) ", type: .Mandatory, supported: .Unsupported),
            RequirementItem(fulfillment: 1, description: "MATHTHxx/MATH4010/CS4860 (Core) ", type: .Mandatory, supported: .Unsupported)
        ]
    }
    
    func analyzeCourse(course: Course) {
        if getThousands(course) == 4 && getHundredths(course) == 8 && getTenths(course) == 1 {
            taken481x.increment(course)
        }
    }
    
    func resetProgress() {
        reqItems.forEach({ (item: RequirementItem) in item.reset() })
    }
}
