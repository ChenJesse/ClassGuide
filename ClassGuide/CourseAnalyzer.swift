//
//  CourseAnalyzer.swift
//  ClassGuide
//
//  Created by Jesse Chen on 3/26/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import Foundation

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
    //remove range
    return specialString
}