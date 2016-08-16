//
//  CourseAnalyzer.swift
//  ClassGuide
//
//  Created by Jesse Chen on 3/26/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import Foundation

public let introCourseNumbers: [Int] = [1110, 1112]
public let nonPracticumProjectsCourseNumbers: [Int] = [4758, 5150, 5152, 5412, 5414, 5431, 5625, 5643, 6670]
public let coreCourseNumbers: [Int] = [2800, 3110, 3410, 4410, 4820]

public func checkPracticum(course: Course) -> Bool {
    //all practicums should be 4000+ and end with a 1
    return (course.courseNumber % 10 == 1) && (course.courseNumber > 4000)
}

public func checkProject(course: Course) -> Bool {
    return nonPracticumProjectsCourseNumbers.contains(course.courseNumber)
}

public func checkIntroProgramming(course: Course) -> Bool {
    return introCourseNumbers.contains(course.courseNumber)
}

public func checkCore(course: Course) -> Bool {
    return coreCourseNumbers.contains(course.courseNumber)
}

public func checkElective(course: Course) -> Bool {
    return course.courseNumber >= 4000
}

public func printSpecialAttributes(course: Course) -> String {
    var specialString = ""
    if checkPracticum(course) { specialString += "Practicum, " }
    if checkProject(course) { specialString += "Project, " }
    if checkIntroProgramming(course) { specialString += "Intro, " }
    if checkCore(course) { specialString += "Core, " }
    if checkElective(course) { specialString += "Elective, " }
    if specialString == "" {
        specialString = "None"
    } else {
        specialString = specialString.chopSuffix(2)
    }

    return specialString
}

public func checkFxxx(course: Course) -> Bool {
    return course.courseNumber >= 4000 && course.courseNumber != 4820 && course.courseNumber != 4090 && course.courseNumber != 4999 && course.courseNumber != 4410 && !checkPracticum(course)
}

public func getThousands(course: Course) -> Int {
    return course.courseNumber / 1000
}

public func getHundredths(course: Course) -> Int {
    return ((course.courseNumber % 1000) / 100)
}

public func getTenths(course: Course) -> Int {
    return (course.courseNumber % 100) / 10
}

public func getOnes(course: Course) -> Int {
    return (course.courseNumber % 10)
}
