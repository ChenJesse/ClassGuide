//
//  Enums.swift
//  ClassGuide
//
//  Created by Jesse Chen on 4/2/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import Foundation

//MARK: Course class enums

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

public enum Special: String {
    case Practicum =    "Practicum"
    case Project =      "Project"
    case Core =         "Core"
    case None =         "None"
}

public enum Season {
    case Fall
    case Spring
}

public enum SettingsKey: String {
    case CS =           "major"
    case AI =           "AI"
    case Renaissance =  "Renaissance"
    case CSE =          "CSE"
    case Graphics =     "Graphics"
    case NS =           "NS"
    case PL =           "PL"
    case SE =           "SE"
    case SD =           "SD"
    case Theory =       "Theory"
    
    static func getDescription(key: SettingsKey) -> String {
        switch key {
        case .CS:
            return majorDescription
        case .AI:
            return AIDescription
        case .Renaissance:
            return renaissanceDescription
        case .CSE:
            return CSEDescription
        case .Graphics:
            return graphicsDescription
        case .NS:
            return NSDescription
        case .PL:
            return PLDescription
        case .SE:
            return SEDescription
        case .SD:
            return SDDescription
        case .Theory:
            return theoryDescription
        }
    }
}

public enum Priority {
    case Mandatory
    case Optional
}

public enum CourseSupport {
    case Supported
    case Unsupported
}
