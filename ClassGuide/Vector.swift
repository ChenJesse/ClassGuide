//
//  Vector.swift
//  ClassGuide
//
//  Created by Jesse Chen on 3/28/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import Foundation

protocol Requirement {
    var requiredCourses: Int { get }
    var completed: Bool { get set }
    func calculateProgress(takenCourses: NSMutableSet, plannedCourses: NSMutableSet)
    func analyzeCourse(course: Course)
    func checkCompletion()
    func resetProgress()
    func printProgress() -> [(String, Float)]
}

class Renaissance: Requirement {
    let title = "Renaissance"
    let requiredCourses = 4
    var completed: Bool = false
    let FxxxRequirement = 4
    let differentHundredthsRequirement = 2
    
    //requires 4 Fxxx courses
    var FxxxCourses = 0
    //requires 2 different hundredths digits
    var differentHundredths = 0
    //requires at least one of the hundredths to be 2 or 8
    var hundredthsIs2or8 = false
    var seenHundredths: [Int] = []
    
    func calculateProgress(takenCourses: NSMutableSet, plannedCourses: NSMutableSet) {
        resetProgress()
        var relevantCourses: [Course] = []
        relevantCourses.appendContentsOf(takenCourses.allObjects as! [Course])
        relevantCourses.appendContentsOf(plannedCourses.allObjects as! [Course])
        for course in relevantCourses {
            analyzeCourse(course)
        }
        
        checkCompletion()
    }
    
    func resetProgress() {
        FxxxCourses = 0
        differentHundredths = 0
        hundredthsIs2or8 = false
        seenHundredths = []
    }
    
    func analyzeCourse(course: Course) {
        let courseIsFXXX = isFXXX(course)
        if courseIsFXXX { FxxxCourses += 1 }
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
    
    func printProgress() -> [(String, Float)] {
        var progress: [(String, Float)] = []
        progress.append(("Taken 4 Fxxx courses?", Float(FxxxCourses) / Float(FxxxRequirement)))
        progress.append(("Taken 2 different hundredths digits (Fxxx courses)?", Float(hundredthsIs2or8) / Float(differentHundredthsRequirement)))
        progress.append(("At least 1 of the Fxxx courses have a 2 or 8 as the hundredths digit?", hundredthsIs2or8 ? 1 : 0))
        return progress
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
    
    func calculateProgress(takenCourses: NSMutableSet, plannedCourses: NSMutableSet) {
        var relevantCourses: [Course] = []
        relevantCourses.appendContentsOf(takenCourses.allObjects as! [Course])
        relevantCourses.appendContentsOf(plannedCourses.allObjects as! [Course])
        for course in relevantCourses {
            analyzeCourse(course)
        }
        
        checkCompletion()
    }
    
    func resetProgress() {
        takenCS4700 = false
        takenCS4701 = false
        takenF78xOrF75x = false
        takenF7xxOr4300orF67xor5846 = false
    }
    
    func checkF78xOrF75x(course: Course) -> Bool {
        return getHundredthsDigit(course) == 7 && (getTenthsDigit(course) == 8 || getTenthsDigit(course) == 5) && isFXXX(course)
    }
    
    func checkF7xxor4300orF67xor5846(course: Course) -> Bool {
        return (
            (isFXXX(course) && getHundredthsDigit(course) == 7 && course.courseNumber != 4700) ||
            course.courseNumber == 4300 ||
            (isFXXX(course) && getHundredthsDigit(course) == 6 && getTenthsDigit(course) == 7) ||
            course.courseNumber == 5846
        )
    }
    
    func analyzeCourse(course: Course) {
        if course.courseNumber == 4700 { takenCS4700 = true }
        if course.courseNumber == 4701 { takenCS4701 = true }
        if checkF78xOrF75x(course) { takenF78xOrF75x = true }
        if checkF7xxor4300orF67xor5846(course) { takenF7xxOr4300orF67xor5846 = true }
    }
    
    func checkCompletion() {
        completed = takenCS4700 && takenCS4701 && takenF78xOrF75x && takenF7xxOr4300orF67xor5846
    }
    
    func printProgress() -> [(String, Float)] {
        var progress: [(String, Float)] = []
        progress.append(("Taken CS4700?", takenCS4700 ? 1 : 0))
        progress.append(("Taken CS4701?", takenCS4701 ? 1 : 0))
        progress.append(("Taken either F78x or F75x?", takenF78xOrF75x ? 1 : 0))
        progress.append(("Taken any one of these: F7xx, 4300, F67x, 5846?", takenF7xxOr4300orF67xor5846 ? 1 : 0))
        return progress
    }
}













