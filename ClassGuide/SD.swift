//
//  SD.swift
//  ClassGuide
//
//  Created by Jesse Chen on 8/15/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import Foundation

class SD: ReqSet {
    static let sharedInstance = SD() as ReqSet
    let title = "System / Databases"
    let key = SettingsKey.SD
    
    var taken4411or4321 = RequirementItem(fulfillment: 1, description: "CS4411/CS4321 (Core) ", type: .Mandatory, supported: .Supported)
    var F4xxorF12xorF32xor5300Fulfilled = RequirementItem(fulfillment: 3, description: "3(CSF4xx/CSF12x/CSF32x/CS5300) (Core) ", type: .Mandatory, supported: .Supported)
    var taken4411 = RequirementItem(fulfillment: 1, description: "CS4411 (Operating Systems, Security & Trustworthy Systems) ", type: .Optional, supported: .Supported)
    var seen: [Int] = []
    var taken5430 = RequirementItem(fulfillment: 1, description: "CS5430 (Security & Trustworthy Systems) ", type: .Optional, supported: .Supported)
    var taken5412or5414 = RequirementItem(fulfillment: 1, description: "CS5412/CS5414 (Security & Trustworthy Systems) ", type: .Optional, supported: .Supported)
    var taken4320 = RequirementItem(fulfillment: 1, description: "CS4320 (Data-Intensive Computing) ", type: .Optional, supported: .Supported)
    var taken5300 = RequirementItem(fulfillment: 1, description: "CS5300 (Data-Intensive Computing) ", type: .Optional, supported: .Supported)
    var taken4321 = RequirementItem(fulfillment: 1, description: "CS4321 (Data-Intensive Computing) ", type: .Optional, supported: .Supported)
    var takenExtraCSF78xor4758or4300or6740 = RequirementItem(fulfillment: 1, description: "Extra CSF78x/CS4758/CS4300/CS6740 (Data-Intensive Computing) ", type: .Optional, supported: .Supported)
    var reqItems: [RequirementItem]!
    
    init() {
        reqItems = [
            taken4411or4321,
            F4xxorF12xorF32xor5300Fulfilled,
            taken4411,
            taken5430,
            taken5412or5414,
            taken4320,
            taken5300,
            taken4321,
            takenExtraCSF78xor4758or4300or6740,
            RequirementItem(fulfillment: 0, description: "CS4830/CS4860/MATH3360 (Security & Trustworthy Systems) ", type: .Optional, supported: .Unsupported)
        ]
        
    }
    
    func analyzeCourse(course: Course) {
        if course.courseNumber == 4411 || course.courseNumber == 4321 {
            taken4411or4321.increment(course)
            if course.courseNumber == 4411 {
                taken4411.increment(course)
            }
        } else if checkF4xxorF12xorF32xor5300(course) && !seen.contains(course.courseNumber) {
            seen.append(course.courseNumber)
            F4xxorF12xorF32xor5300Fulfilled.increment(course)
            if course.courseNumber == 5430 {
                taken5430.increment(course)
            }
            if course.courseNumber == 5412 || course.courseNumber == 5414 {
                taken5412or5414.increment(course)
            }
            if course.courseNumber == 4320 {
                taken4320.increment(course)
            } else if course.courseNumber == 5300 {
                taken5300.increment(course)
            }
        }
        
        if checkF78xor4758or4300or6740(course) {
            takenExtraCSF78xor4758or4300or6740.increment(course)
        }
    }
    
    func checkF78xor4758or4300or6740(course: Course) -> Bool {
        return (
            (checkFxxx(course) && getHundredths(course) == 7 && getTenths(course) == 8) ||
                course.courseNumber == 4758 ||
                course.courseNumber == 4300 ||
                course.courseNumber == 6740
        )
    }
    
    func checkF4xxorF12xorF32xor5300(course: Course) -> Bool {
        let isFxxx = checkFxxx(course)
        let hundredthsDigit = getHundredths(course)
        let tenthsDigit = getTenths(course)
        return (
            (isFxxx && hundredthsDigit == 4) ||
                (isFxxx && hundredthsDigit == 1 && tenthsDigit == 2) ||
                (isFxxx && hundredthsDigit == 3 && tenthsDigit == 2) ||
                course.courseNumber == 5300
        )
    }
    
    func resetProgress() {
        reqItems.forEach({ (item: RequirementItem) in item.reset() })
        seen.removeAll()
    }
}