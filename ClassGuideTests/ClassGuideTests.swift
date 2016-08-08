//
//  ClassGuideTests.swift
//  ClassGuideTests
//
//  Created by Jesse Chen on 3/22/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import XCTest
@testable import ClassGuide

class ClassGuideTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCSMajorRequirements() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let req: CSRequirements = CSRequirements.sharedInstance as! CSRequirements
        let takenCourses: [Course] = [
            Course(number: 1110),
            Course(number: 2110),
            Course(number: 3110),
            Course(number: 3410),
            Course(number: 4410),
            Course(number: 4820),
            Course(number: 4411),
            Course(number: 4000),
            Course(number: 4003),
            Course(number: 4002)
        ]
        req.calculateProgress(NSMutableSet(array: takenCourses), plannedCourses: NSMutableSet())
        XCTAssert(req.taken111x)
        XCTAssert(req.taken2110or2112)
        XCTAssert(req.taken3110)
        XCTAssert(req.taken3410)
        XCTAssert(req.taken4410)
        XCTAssert(req.taken4820)
        XCTAssertEqual(req.electivesFulfilled, 3)
        
        req.resetProgress()
        
        let plannedCourses: [Course] = [Course(number: 2112)]
        
        req.calculateProgress(NSMutableSet(), plannedCourses: NSMutableSet(array: plannedCourses))
        XCTAssert(!req.taken111x)
        XCTAssert(req.taken2110or2112)
        XCTAssert(!req.taken3110)
        XCTAssert(!req.taken3410)
        XCTAssert(!req.taken4410)
        XCTAssert(!req.taken4820)
        XCTAssertEqual(req.electivesFulfilled, 0)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
