//
//  AI.swift
//  ClassGuide
//
//  Created by Jesse Chen on 8/15/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import Foundation

class AI: ReqSet {
    static let sharedInstance = AI() as ReqSet
    let title = "Artificial Intelligence"
    let key = SettingsKey.AI
    
    var takenCS4700 = RequirementItem(fulfillment: 1, description: "CS4700 (Core) ", type: .Mandatory, supported: .Supported)
    var takenCS4701 = RequirementItem(fulfillment: 1, description: "CS4701 (Core) ", type: .Mandatory, supported: .Supported)
    var takenF78xOrF75x = RequirementItem(fulfillment: 1, description: "F78x/F75x (Core) ", type: .Mandatory, supported: .Supported)
    var takenF7xxOr4300orF67xor5846 = RequirementItem(fulfillment: 1, description: "F7xx/4300/F67x/5846 (Core) ", type: .Mandatory, supported: .Supported)
    var takenF74xor4300 = RequirementItem(fulfillment: 1, description: "CSF74x/CS4300 (Human-Language Technology) ", type: .Optional, supported: .Supported)
    var taken4300orF74xorF75xorF67xorF2xx = RequirementItem(fulfillment: 1, description: "CS4300/CSF74x/F75x/F67x/CSF2xx (Machine Learning) ", type: .Optional, supported: .Supported)
    var reqItems: [RequirementItem]!
    
    init() {
        reqItems = [
            takenCS4700,
            takenCS4701,
            takenF78xOrF75x,
            takenF7xxOr4300orF67xor5846,
            takenF74xor4300,
            taken4300orF74xorF75xorF67xorF2xx,
            RequirementItem(fulfillment: 0, description: "LINGFxxx (Human-Language Technology) ", type: .Optional, supported: .Unsupported),
            RequirementItem(fulfillment: 0, description: "LINGFxxx/CSF74x/CSF1110 (Human-Language Technology) ", type: .Optional, supported: .Unsupported),
            RequirementItem(fulfillment: 0, description: "CSF78x/CS4758/CS4850/STSCIFxxx (Machine Learning) ", type: .Optional, supported: .Unsupported)
        ]
    }
    
    func resetProgress() {
        reqItems.forEach({ (item: RequirementItem) in item.reset() })
    }
    
    func checkF78xOrF75x(course: Course) -> Bool {
        return getHundredths(course) == 7 && (getTenths(course) == 8 || getTenths(course) == 5) && checkFxxx(course)
    }
    
    func checkF7xxor4300orF67xor5846(course: Course) -> Bool {
        return (
            (checkFxxx(course) && getHundredths(course) == 7 && course.courseNumber != 4700) ||
                course.courseNumber == 4300 ||
                (checkFxxx(course) && getHundredths(course) == 6 && getTenths(course) == 7) ||
                course.courseNumber == 5846
        )
    }
    
    func checkF74xor4300(course: Course) -> Bool {
        return ((checkFxxx(course) && getHundredths(course) == 7 && getTenths(course) == 4) || course.courseNumber == 4300)
    }
    
    func check4300orF74xorF75xorF67xorF2xx(course: Course) -> Bool {
        let isFxxx = checkFxxx(course)
        let hundredthsDigit = getHundredths(course)
        let tenthsDigit = getTenths(course)
        return (course.courseNumber == 4300 ||
            (isFxxx && hundredthsDigit == 7 && tenthsDigit == 4) ||
            (isFxxx && hundredthsDigit == 7 && tenthsDigit == 5) ||
            (isFxxx && hundredthsDigit == 6 && tenthsDigit == 7) ||
            (isFxxx && hundredthsDigit == 2))
    }
    
    func analyzeCourse(course: Course) {
        if course.courseNumber == 4700 { takenCS4700.increment(course) }
        else if course.courseNumber == 4701 { takenCS4701.increment(course) }
        else if !takenF78xOrF75x.completed && checkF78xOrF75x(course) { takenF78xOrF75x.increment(course) }
        else if checkF7xxor4300orF67xor5846(course) {
            takenF7xxOr4300orF67xor5846.increment(course)
            if (checkFxxx(course) && getHundredths(course) == 7) || course.courseNumber == 4300 {
                takenF74xor4300.increment(course)
            }
        }
        if check4300orF74xorF75xorF67xorF2xx(course) { taken4300orF74xorF75xorF67xorF2xx.increment(course) }
    }
}
