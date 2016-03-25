//
//  DataManager.swift
//  ClassGuide
//
//  Created by Jesse Chen on 3/22/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

internal enum Router: URLStringConvertible {
    static let baseURLString = "https://classes.cornell.edu/api/2.0/search"
    case Root
    case Classes
    
    var URLString: String {
        let path: String = {
            switch self {
            case .Root:
                return "/"
            case .Classes:
                return "/classes.json"
            }
        }()
        return Router.baseURLString + path
    }
}

public class DataManager: NSObject {
    
    public static let sharedInstance = DataManager()
    var courseArray: [Course] = []
    public let semesters = ["FA14", "SP14", "FA15", "SP15", "FA16", "SP16"]
    
    public func fetchCourses(completionHandler: () -> ()) {
        for semester in semesters {
            let _ = Alamofire.request(.GET, Router.Classes, parameters: ["roster": semester, "subject": "CS"])
                .responseJSON { response in
                    switch response.result {
                    case .Success(let data):
                        print("success")
                        self.createCourses(JSON(data), semester: semester)
                        completionHandler()
                    case .Failure(let error):
                        print(error)
                    }
            }
        }
    }
    
    internal func createCourses(json: JSON, semester: String) {
        let courseJSON = json["data"]["classes"].arrayValue
        for c in courseJSON {
            courseArray.append(Course(json: c, sem: semester))
        }
    }

}
