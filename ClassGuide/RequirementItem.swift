//
//  RequirementItem.swift
//  ClassGuide
//
//  Created by Jesse Chen on 4/16/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import Foundation

public class RequirementItem {
    
    var fulfillment: Int
    var satisfied: Int
    var description: String
    var percentage: Float
    var priority: Priority
    var supported: CourseSupport
    var completed: Bool
    var courses: [Course]
    
    public init(fulfillment: Int, description: String, type: Priority, supported: CourseSupport) {
        self.fulfillment = fulfillment
        self.satisfied = 0
        self.description = description
        self.percentage = 0
        self.priority = type
        self.supported = supported
        self.completed = false
        self.courses = []
    }
    
    func reset() {
        satisfied = 0
        percentage = 0
        completed = false
        courses.removeAll()
    }
    
    func increment(course: Course) {
        courses.append(course)
        satisfied += 1
        if !completed {
            percentage = Float(satisfied) / Float(fulfillment)
            completed = (percentage >= 1.0)
        }
    }
}