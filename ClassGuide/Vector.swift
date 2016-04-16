//
//  Vector.swift
//  ClassGuide
//
//  Created by Jesse Chen on 3/28/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import Foundation

class Renaissance: Requirement {
    let title = "Renaissance"
    let requiredCourses = 4
    var completed: Bool = false
    let FxxxRequirement = 4
    let differentHundredthsRequirement = 2
    
    var FxxxCourses = 0
    var seenFxxx: [Int] = []
    var differentHundredths = 0
    var hundredthsIs2or8 = false
    var seenHundredths: [Int] = []
    
    func resetProgress() {
        FxxxCourses = 0
        differentHundredths = 0
        hundredthsIs2or8 = false
        seenHundredths.removeAll()
        seenFxxx.removeAll()
    }
    
    func analyzeCourse(course: Course) {
        let courseIsFXXX = checkFxxx(course)
        if courseIsFXXX && !seenFxxx.contains(course.courseNumber) {
            FxxxCourses += 1
            seenFxxx.append(course.courseNumber)
        }
        if courseIsFXXX && !seenHundredths.contains(getHundredthsDigit(course)) {
            seenHundredths.append(getHundredthsDigit(course))
            differentHundredths += 1
        }
        if courseIsFXXX && (getHundredthsDigit(course) == 2 || getHundredthsDigit(course) == 8) {
            hundredthsIs2or8 = true
        }
    }
    
    func checkCompletion() {
        completed = FxxxCourses >= FxxxRequirement && differentHundredths >= differentHundredthsRequirement && hundredthsIs2or8
    }
    
    func printMandatoryProgress() -> [(String, Float, Priority)] {
        var progress: [(String, Float, Priority)] = []
        progress.append(("4(Fxxx) (Core) ", Float(FxxxCourses) / Float(FxxxRequirement), .Mandatory))
        progress.append(("Fyxx & Fzxx | y != z (Core) ", Float(hundredthsIs2or8) / Float(differentHundredthsRequirement), .Mandatory))
        progress.append(("Fyxx | y == 2 or 8 (Core) ", hundredthsIs2or8 ? 1 : 0, .Mandatory))
        return progress
    }
    
    func printOptionalProgress() -> [(String, Float, Priority)] {
        return []
    }
}

class AI: Requirement {
    let title = "Artificial Intelligence"
    let requiredCourses = 4
    var completed: Bool = false
    var takenCS4700 = false
    var takenCS4701 = false
    var takenF78xOrF75x = false
    var takenF7xxOr4300orF67xor5846 = false
    var takenF74xor4300 = false
    var taken4300orF74xorF75xorF67xorF2xx = false
    
    func resetProgress() {
        takenCS4700 = false
        takenCS4701 = false
        takenF78xOrF75x = false
        takenF7xxOr4300orF67xor5846 = false
        takenF74xor4300 = false
        taken4300orF74xorF75xorF67xorF2xx = false
    }
    
    func checkF78xOrF75x(course: Course) -> Bool {
        return getHundredthsDigit(course) == 7 && (getTenthsDigit(course) == 8 || getTenthsDigit(course) == 5) && checkFxxx(course)
    }
    
    func checkF7xxor4300orF67xor5846(course: Course) -> Bool {
        return (
            (checkFxxx(course) && getHundredthsDigit(course) == 7 && course.courseNumber != 4700) ||
            course.courseNumber == 4300 ||
            (checkFxxx(course) && getHundredthsDigit(course) == 6 && getTenthsDigit(course) == 7) ||
            course.courseNumber == 5846
        )
    }
    
    func checkF74xor4300(course: Course) -> Bool {
        return ((checkFxxx(course) && getHundredthsDigit(course) == 7 && getTenthsDigit(course) == 4) || course.courseNumber == 4300)
    }
    
    func check4300orF74xorF75xorF67xorF2xx(course: Course) -> Bool {
        let isFxxx = checkFxxx(course)
        let hundredthsDigit = getHundredthsDigit(course)
        let tenthsDigit = getTenthsDigit(course)
        return (course.courseNumber == 4300 ||
            (isFxxx && hundredthsDigit == 7 && tenthsDigit == 4) ||
            (isFxxx && hundredthsDigit == 7 && tenthsDigit == 5) ||
            (isFxxx && hundredthsDigit == 6 && tenthsDigit == 7) ||
            (isFxxx && hundredthsDigit == 2))
    }
    
    func analyzeCourse(course: Course) {
        if course.courseNumber == 4700 { takenCS4700 = true }
        else if course.courseNumber == 4701 { takenCS4701 = true }
        else if checkF78xOrF75x(course) { takenF78xOrF75x = true }
        else if checkF7xxor4300orF67xor5846(course) {
            takenF7xxOr4300orF67xor5846 = true
            if (checkFxxx(course) && getHundredthsDigit(course) == 7) || course.courseNumber == 4300 {
                takenF74xor4300 = true
            }
        }
        if check4300orF74xorF75xorF67xorF2xx(course) { taken4300orF74xorF75xorF67xorF2xx = true }
    }
    
    func checkCompletion() {
        completed = takenCS4700 && takenCS4701 && takenF78xOrF75x && takenF7xxOr4300orF67xor5846
    }
    
    func printMandatoryProgress() -> [(String, Float, Priority)] {
        var progress: [(String, Float, Priority)] = []
        progress.append(("CS4700 (Core) ", takenCS4700 ? 1 : 0, .Mandatory))
        progress.append(("CS4701 (Core) ", takenCS4701 ? 1 : 0, .Mandatory))
        progress.append(("F78x/F75x (Core) ", takenF78xOrF75x ? 1 : 0, .Mandatory))
        progress.append(("F7xx/4300/F67x/5846 (Core) ", takenF7xxOr4300orF67xor5846 ? 1 : 0, .Mandatory))
    
        return progress
    }
    
    func printOptionalProgress() -> [(String, Float, Priority)] {
        //Human-Language Technology Track
        var progress: [(String, Float, Priority)] = []
        progress.append(("CSF74x/CS4300 (Human-Language Technology) ", takenF74xor4300 ? 1 : 0, .Optional))
        progress.append(("LINGFxxx (Human-Language Technology) ", unsupportedCourseValue, .Optional))
        progress.append(("LINGFxxx/CSF74x/CSF1110 (Human-Language Technology) ", unsupportedCourseValue, .Optional))
        //Machine Learning
        progress.append(("CSF78x/CS4758/CS4850/STSCIFxxx (Machine Learning) ", unsupportedCourseValue, .Optional))
        progress.append(("CS4300/CSF74x/F75x/F67x/CSF2xx (Machine Learning) ", taken4300orF74xorF75xorF67xorF2xx ? 1 : 0, .Optional))
        
        return progress

    }
}

class CSE: Requirement {
    let title = "Computational Science and Engineering"
    let requiredCourses = 4
    var completed: Bool = false
    let requiredF2xx = 2
    
    var seenF2xx: [Int] = []
    var F2xxFulfilled = 0
    var taken2024 = false
    var taken2043 = false
    
    func analyzeCourse(course: Course) {
        let isFxxx = checkFxxx(course)
        let hundredthsDigit = getHundredthsDigit(course)
        if (isFxxx && hundredthsDigit == 2 && !(seenF2xx.contains(course.courseNumber)) && (
            (!seenF2xx.contains(4220) && !seenF2xx.contains(6210)) ||
            (seenF2xx.contains(4220) && course.courseNumber != 6210) ||
            (seenF2xx.contains(6210) && course.courseNumber != 4220))) {
            seenF2xx.append(course.courseNumber)
            F2xxFulfilled += 1
        } else if course.courseNumber == 2024 {
            taken2024 = true
        } else if course.courseNumber == 2043 {
            taken2043 = true
        }
    }
    
    func resetProgress() {
        F2xxFulfilled = 0
        taken2024 = false
        taken2043 = false
        seenF2xx.removeAll()
    }
    
    func checkCompletion() {
        completed = (F2xxFulfilled >= requiredF2xx && taken2024 && taken2043)
    }
    
    func printMandatoryProgress() -> [(String, Float, Priority)] {
        var progress: [(String, Float, Priority)] = []
        progress.append(("2(F2xx), CS4220 & CS6210 = 1 (Core) ", Float(F2xxFulfilled) / Float(requiredF2xx), .Mandatory))
        progress.append(("OR3300/TAM3100/MATH4200/MATH4240/MATH4280/AEP4210/CEE3310/CEE3710/MAE3230 (Core) ", unsupportedCourseValue, .Mandatory))
        progress.append(("CS2024 (Core) ", taken2024 ? 1 : 0, .Mandatory))
        progress.append(("CS2043 (Core) ", taken2043 ? 1 : 0, .Mandatory))
        
        return progress
    }
    
    func printOptionalProgress() -> [(String, Float, Priority)] {
        return []
    }
}

class Graphics: Requirement {
    let title = "Graphics"
    let requiredCourses = 5
    var completed: Bool = false
    
    var taken4620 = false
    var taken4621 = false
    var takenF2xx = false
    var taken5625or5643or6620or6630or6640or6650 = false
    var takenF6xxor3152or4152or4154 = false
    
    func analyzeCourse(course: Course) {
        if (course.courseNumber == 4620) { taken4620 = true }
        else if (course.courseNumber == 4621) { taken4621 = true }
        else if check5625or5643or6620or6630or6640or6650(course) { taken5625or5643or6620or6630or6640or6650 = true }
        else if checkF6xxor3152or4152or4154(course) { takenF6xxor3152or4152or4154 = true }
    }
    
    func checkF6xxor3152or4152or4154(course: Course) -> Bool {
        return (
            (checkFxxx(course) && getHundredthsDigit(course) == 6) ||
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
        taken4620 = false
        taken4621 = false
        takenF2xx = false
        taken5625or5643or6620or6630or6640or6650 = false
        takenF6xxor3152or4152or4154 = false
    }
    
    func checkCompletion() {
        completed = taken4620 && taken4621 && takenF2xx && taken5625or5643or6620or6630or6640or6650 && takenF6xxor3152or4152or4154
    }
    
    func printMandatoryProgress() -> [(String, Float, Priority)] {
        var progress: [(String, Float, Priority)] = []
        progress.append(("CS4620 (Core) ", taken4620 ? 1 : 0, .Mandatory))
        progress.append(("CS621 (Core) ", taken4621 ? 1 : 0, .Mandatory))
        progress.append(("CSF2xx (Core) ", takenF2xx ? 1 : 0, .Mandatory))
        progress.append(("CS5625/CS5643/CS6620/CS6630/CS6640/CS6650 (Core) ", taken5625or5643or6620or6630or6640or6650 ? 1 : 0, .Mandatory))
        progress.append(("CS56xx/CS3152/CS4152/CS5154 (Core) ", takenF6xxor3152or4152or4154 ? 1 : 0, .Mandatory))
        return progress
    }
    
    func printOptionalProgress() -> [(String, Float, Priority)] {
        return []
    }
}

class NS: Requirement {
    let title = "Network Science"
    let requiredCourses = 4
    var completed: Bool = false
    let requiredx85xor4220 = 2
    
    var x85xor4220Fulfilled = 0
    var seen: [Int] = []
    var takenF76xor4758 = false
    
    
    func analyzeCourse(course: Course) {
        let isFxxx = checkFxxx(course)
        if (isFxxx && !seen.contains(course.courseNumber) &&
            (getTenthsDigit(course) == 8 && getonesDigit(course) == 5) || course.courseNumber == 4220)  {
            seen.append(course.courseNumber)
            x85xor4220Fulfilled += 1
        } else if (isFxxx && ((getHundredthsDigit(course) == 7 && getTenthsDigit(course) == 8) || course.courseNumber == 4758)) {
            takenF76xor4758 = true
        }
    }
    
    func resetProgress() {
        x85xor4220Fulfilled = 0
        seen.removeAll()
        takenF76xor4758 = false
    }
    
    func checkCompletion() {
        completed = x85xor4220Fulfilled >= requiredx85xor4220 && takenF76xor4758
    }
    
    func printMandatoryProgress() -> [(String, Float, Priority)] {
        var progress: [(String, Float, Priority)] = []
        progress.append(("CSx86x/INFO4220 (Core) ", unsupportedCourseValue, .Mandatory))
        progress.append(("CSF76x/4758 (Core) ", takenF76xor4758 ? 1 : 0, .Mandatory))
        progress.append(("ORIEx350/ECON4010/ECON4020/SOC3040/SOC4250/SOC5270/CSF84x/INFO4220 (Core) ", unsupportedCourseValue,.Mandatory))
        return progress
    }
    
    func printOptionalProgress() -> [(String, Float, Priority)] {
        return []
    }
}

class PL: Requirement {
    let title = "Programming Languages"
    let requiredCourses = 5
    var completed: Bool = false
    
    var takenF110 = false
    var taken4120 = false
    var taken4121 = false
    var taken4860or5114or5860orF810or6110 = false
    var taken202x = false

    func analyzeCourse(course: Course) {
        let isFxxx = checkFxxx(course)
        let thousandsDigit = getThousandsDigit(course)
        let hundredthsDigit = getHundredthsDigit(course)
        let tenthsDigit = getTenthsDigit(course)
        let onesDigit = getonesDigit(course)
        if isFxxx && hundredthsDigit == 1 && tenthsDigit == 1 && onesDigit == 0 {
            takenF110 = true
        } else if course.courseNumber == 4120 {
            taken4120 = true
        } else if course.courseNumber == 4121 {
            taken4121 = true
        } else if (course.courseNumber == 4860 || course.courseNumber == 5114 || course.courseNumber == 5860 ||
                    (isFxxx && hundredthsDigit == 8 && tenthsDigit == 1 && onesDigit == 0) || course.courseNumber == 6110) {
            taken4860or5114or5860orF810or6110 = true
        } else if (thousandsDigit == 2 && hundredthsDigit == 0 && tenthsDigit == 2) {
            taken202x = true
        }
    }

    func resetProgress() {
        takenF110 = false
        taken4120 = false
        taken4121 = false
        taken4860or5114or5860orF810or6110 = false
        taken202x = false
    }

    func checkCompletion() {
        completed = takenF110 && taken4120 && taken4121 && taken4860or5114or5860orF810or6110 && taken202x
    }

    func printMandatoryProgress() -> [(String, Float, Priority)] {
        var progress: [(String, Float, Priority)] = []
        progress.append(("CSF110 (Core) ", takenF110 ? 1 : 0, .Mandatory))
        progress.append(("CS4120 (Core) ", taken4120 ? 1 : 0, .Mandatory))
        progress.append(("CS4121 (Core) ", taken4121 ? 1 : 0, .Mandatory))
        progress.append(("CS4860/CS5114/CS5860/CSF810/CS6110 (Core) ", taken4860or5114or5860orF810or6110 ? 1 : 0, .Mandatory))
        progress.append(("CS202x (Core) ", taken202x ? 1 : 0, .Mandatory))
        return progress
    }
    
    func printOptionalProgress() -> [(String, Float, Priority)] {
        return []
    }
}

class SE: Requirement {
    let title = "Software Engineering"
    let requiredCourses = 5
    var completed: Bool = false
    let requiredPracticums = 2
    
    var taken5150or5152 = false
    var practicumsFulfilled = 0
    var seenPracticums: [Int] = []
    var taken4152or4154orF45xor5300or5412or5414or5625or5643or6620or6630or6650 = false

    func analyzeCourse(course: Course) {
        if course.courseNumber == 5150 || course.courseNumber == 5152 {
            taken5150or5152 = true
        } else if checkPracticum(course) && !seenPracticums.contains(course.courseNumber) {
            seenPracticums.append(course.courseNumber)
            practicumsFulfilled += 1
        } else if checkHeavyImplementationComponent(course) {
            taken4152or4154orF45xor5300or5412or5414or5625or5643or6620or6630or6650 = true
        }
    }
    
    func checkHeavyImplementationComponent(course: Course) -> Bool {
        return (
            course.courseNumber == 4152 ||
            course.courseNumber == 4154 ||
            checkFxxx(course) && getHundredthsDigit(course) == 4 && getTenthsDigit(course) == 5 ||
            course.courseNumber == 5300 ||
            course.courseNumber == 5412 ||
            course.courseNumber == 5414 ||
            course.courseNumber == 5625 ||
            course.courseNumber == 5643 ||
            course.courseNumber == 6620 ||
            course.courseNumber == 6630 ||
            course.courseNumber == 6650
        )
    }

    func resetProgress() {
        taken5150or5152 = false
        practicumsFulfilled = 0
        seenPracticums.removeAll()
        taken4152or4154orF45xor5300or5412or5414or5625or5643or6620or6630or6650 = false
    }

    func checkCompletion() {
        completed = taken5150or5152 && practicumsFulfilled >= requiredPracticums && taken4152or4154orF45xor5300or5412or5414or5625or5643or6620or6630or6650
    }

    func printMandatoryProgress() -> [(String, Float, Priority)] {
        var progress: [(String, Float, Priority)] = []
        progress.append(("CS5150/CS5152 (Core) ", taken5150or5152 ? 1 : 0, .Mandatory))
        progress.append(("2(Practicums) (Core) ", Float(practicumsFulfilled) / Float(requiredPracticums), .Mandatory))
        progress.append(("CS4152/CS4154/CSF45x/CS5300/CS5412/CS5414/CS5625/CS5643/CS6620/CS6630/CS6650 (Core) ",
            taken4152or4154orF45xor5300or5412or5414or5625or5643or6620or6630or6650 ? 1 : 0, .Mandatory))
        return progress
    }
    
    func printOptionalProgress() -> [(String, Float, Priority)] {
        return []
    }
}

class SD: Requirement {
    let title = "System / Databases"
    let requiredCourses: Int = 4
    var completed: Bool = false
    var requiredF4xxorF12xorF32xor5300 = 3
    
    var taken4411 = false
    var taken4321 = false
    var seen: [Int] = []
    var F4xxorF12xorF32xor5300Fulfilled = 0
    var taken5430 = false
    var taken5412or5414 = false
    var taken4320 = false
    var taken5300 = false
    var takenExtraCSF78xor4758or4300or6740 = false
    
    func analyzeCourse(course: Course) {
        if course.courseNumber == 4411 {
            taken4411 = true
        } else if course.courseNumber == 4321 {
            taken4321 = true
        } else if checkF4xxorF12xorF32xor5300(course) && !seen.contains(course.courseNumber) {
            seen.append(course.courseNumber)
            F4xxorF12xorF32xor5300Fulfilled += 1
            if course.courseNumber == 5430 {
                taken5430 = true
            }
            if course.courseNumber == 5412 || course.courseNumber == 5414 {
                taken5412or5414 = true
            }
            if course.courseNumber == 4320 {
                taken4320 = true
            }
            if course.courseNumber == 5300 {
                taken5300 = true
            }
            if F4xxorF12xorF32xor5300Fulfilled >= requiredF4xxorF12xorF32xor5300 {
                if checkF78xor4758or4300or6740(course) {
                    takenExtraCSF78xor4758or4300or6740 = true
                }
            }
        }
    }
    
    func checkF78xor4758or4300or6740(course: Course) -> Bool {
        return (
            (checkFxxx(course) && getHundredthsDigit(course) == 7 && getTenthsDigit(course) == 8) ||
            course.courseNumber == 4758 ||
            course.courseNumber == 4300 ||
            course.courseNumber == 6740
        )
    }
    
    func checkF4xxorF12xorF32xor5300(course: Course) -> Bool {
        let isFxxx = checkFxxx(course)
        let hundredthsDigit = getHundredthsDigit(course)
        let tenthsDigit = getTenthsDigit(course)
        return (
            (isFxxx && hundredthsDigit == 4) ||
            (isFxxx && hundredthsDigit == 1 && tenthsDigit == 2) ||
            (isFxxx && hundredthsDigit == 3 && tenthsDigit == 2) ||
            course.courseNumber == 5300
        )
    }
    
    func resetProgress() {
        taken4411 = false
        taken4321 = false
        seen.removeAll()
        F4xxorF12xorF32xor5300Fulfilled = 0
        taken5430 = false
        taken5412or5414 = false
        taken4320 = false
        taken5300 = false
        takenExtraCSF78xor4758or4300or6740 = false
    }
    
    func checkCompletion() {
        completed = taken4411 && taken4321 && F4xxorF12xorF32xor5300Fulfilled >= requiredF4xxorF12xorF32xor5300
    }
    
    func printMandatoryProgress() -> [(String, Float, Priority)] {
        var progress: [(String, Float, Priority)] = []
        progress.append(("CS4411/CS4321 (Core) ", (taken4411 || taken4321) ? 1 : 0, .Mandatory))
        progress.append(("3(CSF4xx/CSF12x/CSF32x/CS5300) (Core) ", Float(F4xxorF12xorF32xor5300Fulfilled) / Float(requiredF4xxorF12xorF32xor5300), .Mandatory))
        return progress
    }
    
    func printOptionalProgress() -> [(String, Float, Priority)] {
        var progress: [(String, Float, Priority)] = []
        progress.append(("CS4411 (Operating Systems, Security & Trustworthy Systems) ", taken4411 ? 1 : 0, .Optional))
        progress.append(("CS5430 (Security & Trustworthy Systems) ", taken5430 ? 1 : 0, .Optional))
        progress.append(("CS5412/CS5414 (Security & Trustworthy Systems) ", taken5412or5414 ? 1 : 0, .Optional))
        progress.append(("CS4830/CS4860/MATH3360 (Security & Trustworthy Systems) ", unsupportedCourseValue, .Optional))
        progress.append(("CS4321 (Data-Intensive Computing) ", taken4321 ? 1 : 0, .Optional))
        progress.append(("CS4320 & CS5300 (Data-Intensive Computing) ", (taken4320 && taken5300) ? 1 : 0, .Optional))
        progress.append(("Extra CSF78x/CS4758/CS4300/CS6740 (Data-Intensive Computing) ", takenExtraCSF78xor4758or4300or6740 ? 1 : 0, .Optional))
        return progress
    }
}

class Theory: Requirement {
    let title = "Theory"
    let requiredCourses: Int = 4
    var completed: Bool = false
    
    var taken481x = false
    
    func analyzeCourse(course: Course) {
        if getThousandsDigit(course) == 4 && getHundredthsDigit(course) == 8 && getTenthsDigit(course) == 1 {
            taken481x = true
        }
    }
    
    func resetProgress() {
        taken481x = false
    }
    
    func checkCompletion() {
        completed = taken481x
    }
    
    func printMandatoryProgress() -> [(String, Float, Priority)] {
        var progress: [(String, Float, Priority)] = []
        progress.append(("CS481x (Core) ", taken481x ? 1 : 0, .Mandatory))
        progress.append(("2(CSF8xx/ORIE6330/ORIE6335) (Core) ", unsupportedCourseValue, .Mandatory))
        progress.append(("MATHTHxx/MATH4010/CS4860 (Core) (M0", unsupportedCourseValue, .Mandatory))
        return progress
    }
    
    func printOptionalProgress() -> [(String, Float, Priority)] {
        return []
    }
}

