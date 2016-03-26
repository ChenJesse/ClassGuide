//
//  Course.swift
//  ClassGuide
//
//  Created by Jesse Chen on 3/22/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

public enum Subject: String {
    case CS =         "CS"
    case Physics =    "PHYS"
    case Economics =  "ECON"
    case Other =      "Other"
}

public enum Distribution : String {
    case PBS =      "(PBS)"
    case MQR =      "(MQR)"
    case HA  =      "(HA-AS)"
    case KCM =      "(KCM)"
    case LA  =      "(LA-AS)"
    case SBA =      "(SBA)"
    case None =     "None"
}

public enum Consent : String {
    case None  =     "No consent required"
    case Dept  =     "Department consent required"
    case Instr =     "Instructor consent required"
}

public enum Special: String {
    case Practicum =    "Practicum"
    case Project =      "Project"
    case Core =         "Core"
    case None =         "None"
}

public enum Status: String {
    case Taken =    "Taken"
    case PlanTo =   "Plan to Take"
    case None =     "None"
}

public enum Semester: String {
    case FA14 = "FA14"
    case SP14 = "SP14"
    case FA15 = "FA15"
    case SP15 = "SP15"
    case FA16 = "FA16"
    case SP16 = "SP16"
    case Other = "Other"
}

public enum APIKey : String {
    case Subject =       "subject"
    case CourseNumber =  "catalogNbr"
    case Instructors =   "instructors"
    case Distribution =  "catalogDistr"
    case Consent =       "addConsentDescr"
    case TitleShort =    "titleShort"
    case TitleLong =     "titleLong"
    case CourseID =      "crseID"
    case Description =   "description"
    case Prerequisites = "catalogPrereqCoreq"
}

//All the project courses that are not practicums (practicums are a subset)
public let nonPracticumProjectsCourseNumbers: [Int] = [4758, 5150, 5152, 5412, 5414, 5431, 5625, 5643, 6670]
public let coreCourseNumbers: [Int] = [2800, 3110, 3410, 4410, 4820]

public class Course {
    public let semester: Semester
    public let subject: Subject
    public let courseNumber: Int
    public var instructors: String = ""
    public let distributionRequirement: Distribution
    public let consent: Consent
    public let titleShort: String
    public let titleLong: String
    public let courseID: Int
    public let description: String
    public var prerequisites: String //Should technically be a [Course], need to parse it somehow
    public let special: Special
    public let status: Status
    
    internal init(json: JSON, sem: String) {
        semester = Semester(rawValue: sem) ?? .Other
        subject = Subject(rawValue: json[APIKey.Subject.rawValue].stringValue) ?? .Other
        courseNumber = json[APIKey.CourseNumber.rawValue].intValue
        distributionRequirement = Distribution(rawValue: json[APIKey.Distribution.rawValue].stringValue) ?? .None
        consent = Consent(rawValue: json[APIKey.Consent.rawValue].stringValue) ?? .None
        titleShort = json[APIKey.TitleShort.rawValue].stringValue
        titleLong = json[APIKey.TitleLong.rawValue].stringValue
        courseID = json[APIKey.CourseID.rawValue].intValue
        description = json[APIKey.Description.rawValue].stringValue
        prerequisites = (json[APIKey.Prerequisites.rawValue].stringValue != "") ? json[APIKey.Prerequisites.rawValue].stringValue : "None"
        status = .None //initially nothing is taken
        //appending instructor objects
        //for instructorJSON in json[APIKey.Instructors.rawValue].arrayValue {
        //    instructors.append(Instructor(json: instructorJSON))
        //}
        //determining the "special" field
        for instructorJSON in json["enrollGroups"][0]["classSections"][0]["meetings"][0]["instructors"].arrayValue {
            instructors += "\(instructorJSON["firstName"].stringValue) \(instructorJSON["lastName"].stringValue), "
        }
        instructors = String(instructors.characters.dropLast())
        print(instructors)
        if courseNumber % 10 == 1 {
            special = .Practicum
        } else if nonPracticumProjectsCourseNumbers.contains(courseNumber) {
            special = .Project
        } else if coreCourseNumbers.contains(courseNumber) {
            special = .Core
        } else {
            special = .None
        }
    }
    
    internal init(savedCourse: NSManagedObject) {
        semester = Semester(rawValue: savedCourse.valueForKey("semester") as! String) ?? .Other
        subject = Subject(rawValue: savedCourse.valueForKey("subject") as! String) ?? .Other
        courseNumber = savedCourse.valueForKey("courseNumber") as! Int
        distributionRequirement = Distribution(rawValue: savedCourse.valueForKey("distributionRequirement") as! String) ?? .None
        consent = Consent(rawValue: savedCourse.valueForKey("consent") as! String) ?? .None
        titleShort = savedCourse.valueForKey("titleShort") as! String
        titleLong = savedCourse.valueForKey("titleLong") as! String
        courseID =  savedCourse.valueForKey("courseID") as! Int
        description = savedCourse.valueForKey("descr") as! String
        prerequisites = savedCourse.valueForKey("prerequisites") as! String
        status = Status(rawValue: savedCourse.valueForKey("status") as! String) ?? .None
        instructors = savedCourse.valueForKey("instructors") as! String 
        special = Special(rawValue: savedCourse.valueForKey("special") as! String) ?? .None
    }
  
}

