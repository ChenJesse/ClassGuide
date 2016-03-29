//
//  Vector.swift
//  ClassGuide
//
//  Created by Jesse Chen on 3/28/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import Foundation

protocol Vector {
    var requiredCourses: Int { get }
    var completed: Bool { get set }
    func updateProgress(takenCourses: NSMutableSet, plannedCourses: NSMutableSet)
    func resetProgress()
}

class Renaissance: Vector {
    let requiredCourses = 4
    var completed: Bool
    
    //requires 4 Fxxx courses
    var FxxxCourses = 0
    //requires 2 different hundredths digits
    var differentHundredths = 0
    //requires at least one of the hundredths to be 2 or 8
    var hundredthsIs2or8 = false
    var seenHundredths: [Int] = []
    
    internal init() {
        completed = false
    }
    
    func updateProgress(takenCourses: NSMutableSet, plannedCourses: NSMutableSet) {
        resetProgress()
        var relevantCourses: [Course] = []
        relevantCourses.appendContentsOf(takenCourses.allObjects as! [Course])
        relevantCourses.appendContentsOf(plannedCourses.allObjects as! [Course])
        for course in relevantCourses {
            let courseIsFXXX = isFXXX(course)
            if courseIsFXXX { FxxxCourses += 1 }
            if courseIsFXXX && !seenHundredths.contains(getHundredthsDigit(course)) {
                seenHundredths.append(getHundredthsDigit(course))
                differentHundredths += 1
            }
            if getHundredthsDigit(course) == 2 || getHundredthsDigit(course) == 8 {
                hundredthsIs2or8 = true
            }
        }
        
        if FxxxCourses >= 4 && differentHundredths >= 2 && hundredthsIs2or8 {
            completed = true
        }
    }
    
    func resetProgress() {
        FxxxCourses = 0
        differentHundredths = 0
        hundredthsIs2or8 = false
        seenHundredths = []
    }
}

class AI: Vector {
    let requiredCourses = 4
    var completed: Bool
    var takenCS4700 = false
    var takenCS4701 = false
    var takenF78xOrF75x = false
    var takenF7xxOr4300orF67xor5846 = false
    
    internal init() {
        completed = false
    }
    
    func updateProgress(takenCourses: NSMutableSet, plannedCourses: NSMutableSet) {
        var relevantCourses: [Course] = []
        relevantCourses.appendContentsOf(takenCourses.allObjects as! [Course])
        relevantCourses.appendContentsOf(plannedCourses.allObjects as! [Course])
        for course in relevantCourses {
            if course.courseNumber == 4700 { takenCS4700 = true }
            if course.courseNumber == 4701 { takenCS4701 = true }
            if checkF78xOrF75x(course) { takenF78xOrF75x = true }
            if checkF7xxor4300orF67xor5846(course) { takenF7xxOr4300orF67xor5846 = true }
        }
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
            (isFXXX(course) && getHundredthsDigit(course) == 7) ||
            course.courseNumber == 4300 ||
            (isFXXX(course) && getHundredthsDigit(course) == 6 && getTenthsDigit(course) == 7) ||
            course.courseNumber == 5846
        )
    }
}













