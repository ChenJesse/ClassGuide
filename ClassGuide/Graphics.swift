//
//  Graphics.swift
//  ClassGuide
//
//  Created by Jesse Chen on 8/15/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import Foundation

class Graphics: ReqSet {
    static let sharedInstance = Graphics() as ReqSet
    let title = "Graphics"
    let key = SettingsKey.Graphics
    
    var taken4620 = RequirementItem(fulfillment: 1, description: "CS4620 (Core) ", type: .Mandatory, supported: .Supported)
    var taken4621 = RequirementItem(fulfillment: 1, description: "CS4621 (Core) ", type: .Mandatory, supported: .Supported)
    var takenF2xx = RequirementItem(fulfillment: 1, description: "CSF2xx (Core) ", type: .Mandatory, supported: .Supported)
    var taken5625or5643or6620or6630or6640or6650 = RequirementItem(fulfillment: 1, description: "CS5625/CS5643/CS6620/CS6630/CS6640/CS6650 (Core) ", type: .Mandatory, supported: .Supported)
    var takenF6xxor3152or4152or4154 = RequirementItem(fulfillment: 1, description: "CS56xx/CS3152/CS4152/CS5154 (Core) ", type: .Mandatory, supported: .Supported)
    var reqItems: [RequirementItem]!
    
    init() {
        reqItems = [
            taken4620,
            taken4621,
            takenF2xx,
            takenF6xxor3152or4152or4154,
            taken5625or5643or6620or6630or6640or6650
        ]
    }
    
    func analyzeCourse(course: Course) {
        if (course.courseNumber == 4620) { taken4620.increment(course) }
        else if (course.courseNumber == 4621) { taken4621.increment(course) }
        else if checkF2xx(course) { takenF2xx.increment(course) }
        else if check5625or5643or6620or6630or6640or6650(course) { taken5625or5643or6620or6630or6640or6650.increment(course) }
        else if checkF6xxor3152or4152or4154(course) { takenF6xxor3152or4152or4154.increment(course) }
    }
    
    func checkF2xx(course: Course) -> Bool {
        return (checkFxxx(course) && getHundredths(course) == 2)
    }
    
    func checkF6xxor3152or4152or4154(course: Course) -> Bool {
        return (
            (checkFxxx(course) && getHundredths(course) == 6) ||
                course.courseNumber == 3152 ||
                course.courseNumber == 4152 ||
                course.courseNumber == 4154
        )
    }
    
    func check5625or5643or6620or6630or6640or6650(course: Course) -> Bool {
        return (
            course.courseNumber == 5625 ||
                course.courseNumber == 5643 ||
                course.courseNumber == 6620 ||
                course.courseNumber == 6630 ||
                course.courseNumber == 6640 ||
                course.courseNumber == 6650
        )
    }
    
    func resetProgress() {
        reqItems.forEach({ (item: RequirementItem) in item.reset() })
    }
}