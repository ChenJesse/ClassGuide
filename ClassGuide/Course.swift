//
//  Course.swift
//  ClassGuide
//
//  Created by Jesse Chen on 3/22/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import Foundation
import SwiftyJSON

public enum Subject: String {
    case CS =         "CS"
    case Physics =    "PHYS"
    case Economics =  "ECON"
    case Other =      "Other"
}

public enum Distribution : String {
    case PBS =      "PBS"
    case MQR =      "MQR"
    case HA  =      "HA-AS"
    case KCM =      "KCM"
    case LA  =      "LA-AS"
    case SBA =      "SBA"
    case None =     "None"
}

public enum Consent : String {
    case None  =     "No consent required"
    case Dept  =     "Department consent required"
    case Instr =     "Instructor consent required"
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

public class Course {
    public let subject: Subject
    public let courseNumber: Int
    public var instructors: [Instructor] = []
    public let distributionRequirement: Distribution
    public let consent: Consent
    public let titleShort: String
    public let titleLong: String
    public let courseID: Int
    public let description: String
    public let prerequisites: String //Should technically be a [Course], need to parse it somehow
    
    internal init(json: JSON) {
        subject = Subject(rawValue: json[APIKey.Subject.rawValue].stringValue) ?? .Other
        courseNumber = json[APIKey.CourseNumber.rawValue].intValue
        distributionRequirement = Distribution(rawValue: json[APIKey.Distribution.rawValue].stringValue) ?? .None
        consent = Consent(rawValue: json[APIKey.Consent.rawValue].stringValue) ?? .None
        titleShort = json[APIKey.TitleShort.rawValue].stringValue
        titleLong = json[APIKey.TitleLong.rawValue].stringValue
        courseID = json[APIKey.CourseID.rawValue].intValue
        description = json[APIKey.Description.rawValue].stringValue
        prerequisites = json[APIKey.Prerequisites.rawValue].stringValue
        for instructorJSON in json[APIKey.Instructors.rawValue].arrayValue {
            instructors.append(Instructor(json: instructorJSON))
        }
    }
}

