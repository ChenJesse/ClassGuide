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

public enum Status: Int {
    case Taken =    2
    case PlanTo =   1
    case None =     0
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

public func ==(lhs: Course, rhs: Course) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

public class Course: Hashable {
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
    public var status: Status
    
    public var hashValue: Int {
        get {
            return (subject.rawValue + "\(courseNumber) \(semester.rawValue)").hashValue
        }
    }
    
    internal init(json: JSON, sem: String, stat: Status) {
        semester = Semester(rawValue: sem) ?? .Other
        subject = Subject(rawValue: json[APIKey.Subject.rawValue].stringValue) ?? .Other
        courseNumber = json[APIKey.CourseNumber.rawValue].intValue
        distributionRequirement = Distribution(rawValue: json[APIKey.Distribution.rawValue].stringValue) ?? .None
        consent = Consent(rawValue: json[APIKey.Consent.rawValue].stringValue) ?? .None
        titleShort = json[APIKey.TitleShort.rawValue].stringValue
        titleLong = json[APIKey.TitleLong.rawValue].stringValue
        //TODO: Get courseID working again
        courseID = json[APIKey.CourseID.rawValue].intValue
        description = json[APIKey.Description.rawValue].stringValue
        prerequisites = (json[APIKey.Prerequisites.rawValue].stringValue != "") ? json[APIKey.Prerequisites.rawValue].stringValue : "None"
        status = stat //initially nothing is taken
        processInstructors(json)
        instructors = instructors.chopSuffix(2) //remove last two characters
    }
    
    convenience init(json: JSON, sem: String) {
        self.init(json: json, sem: sem, stat: .None)
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
        status = Status(rawValue: savedCourse.valueForKey("status") as! Int) ?? .None
        instructors = savedCourse.valueForKey("instructors") as! String
    }
    
    func processInstructors(json: JSON) {
        for instructorJSON in json["enrollGroups"][0]["classSections"][0]["meetings"][0]["instructors"].arrayValue {
            instructors += "\(instructorJSON["firstName"].stringValue) \(instructorJSON["lastName"].stringValue), "
        }
    }
}

