//
//  Instructor.swift
//  ClassGuide
//
//  Created by Jesse Chen on 3/22/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import Foundation
import SwiftyJSON

public enum InstrAPIKey : String {
    case Netid =        "netid"
    case FirstName =    "firstName"
    case MiddleName =   "middleName"
    case LastName =     "lastName"
}

public class Instructor {
    public let netid: String
    public let firstName: String
    public let middleName: String
    public let lastName: String
    
    public init(id: String, first: String, middle: String, last: String) {
        netid = id
        firstName = first
        middleName = middle
        lastName = last
    }
    
    internal init(json: JSON) {
        netid = json[InstrAPIKey.Netid.rawValue].stringValue
        firstName = json[InstrAPIKey.FirstName.rawValue].stringValue
        middleName = json[InstrAPIKey.MiddleName.rawValue].stringValue
        lastName = json[InstrAPIKey.LastName.rawValue].stringValue
    }
}
