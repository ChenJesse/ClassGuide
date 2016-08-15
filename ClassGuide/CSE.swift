//
//  CSE.swift
//  ClassGuide
//
//  Created by Jesse Chen on 8/15/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import Foundation

class CSE: ReqSet {
    static let sharedInstance = CSE() as ReqSet
    let title = "Computational Science and Engineering"
    let key = SettingsKey.CSE
    
    var seenF2xx: [Int] = []
    var seen20xx: [Int] = []
    var F2xxFulfilled = RequirementItem(fulfillment: 2, description: "2(F2xx), CS4220 & CS6210 = 1 (Core) ", type: .Mandatory, supported: .Supported)
    var taken20xx = RequirementItem(fulfillment: 2, description: "2 out of: CS2024, CS2022, CS2043 (Core) ", type: .Mandatory, supported: .Supported)
    
    var reqItems: [RequirementItem]!
    
    init() {
        reqItems = [
            F2xxFulfilled,
            taken20xx,
            RequirementItem(fulfillment: 0, description: "OR3300/TAM3100/MATH4200/MATH4240/MATH4280/AEP4210/CEE3310/CEE3710/MAE3230 (Core) ", type: .Mandatory, supported: .Unsupported)
        ]
    }
    
    func analyzeCourse(course: Course) {
        let isFxxx = checkFxxx(course)
        let hundredthsDigit = getHundredths(course)
        let thousandthsDigit = getThousands(course)
        if (isFxxx && hundredthsDigit == 2 && !(seenF2xx.contains(course.courseNumber)) && (
            (!seenF2xx.contains(4220) && !seenF2xx.contains(6210)) ||
                (seenF2xx.contains(4220) && course.courseNumber != 6210) ||
                (seenF2xx.contains(6210) && course.courseNumber != 4220))) {
            seenF2xx.append(course.courseNumber)
            F2xxFulfilled.increment(course)
        } else if thousandthsDigit == 2 && hundredthsDigit == 0 && !(seen20xx.contains(course.courseNumber)) {
            seen20xx.append(course.courseNumber)
            taken20xx.increment(course)
        }
    }
    
    func resetProgress() {
        reqItems.forEach({ (item: RequirementItem) in item.reset() })
        seenF2xx.removeAll()
        seen20xx.removeAll()
    }
}