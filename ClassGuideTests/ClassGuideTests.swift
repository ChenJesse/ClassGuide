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
    
    func testRenaissance() {
        let req: Renaissance = Renaissance.sharedInstance as! Renaissance
        var takenCourses: [Course] = [
            Course(number: 4110),
            Course(number: 4320),
            Course(number: 5320),
            Course(number: 4999),
            Course(number: 4820),
            Course(number: 4090),
            Course(number: 4410),
            Course(number: 5112)
        ]
        req.calculateProgress(NSMutableSet(array: takenCourses), plannedCourses: NSMutableSet())
        XCTAssertEqual(req.FxxxCourses, 4)
        XCTAssertEqual(req.differentHundredths, 2)
        XCTAssert(!req.hundredthsIs2or8)
        takenCourses.append(Course(number: 4200))
        req.calculateProgress(NSMutableSet(array: takenCourses), plannedCourses: NSMutableSet())
        XCTAssertEqual(req.FxxxCourses, 5)
        XCTAssertEqual(req.differentHundredths, 3)
        XCTAssert(req.hundredthsIs2or8)
    }
    
    func testAI() {
        let req: AI = AI.sharedInstance as! AI
        var takenCourses: [Course] = [
            Course(number: 4700),
            Course(number: 4701),
            Course(number: 4788),
            Course(number: 4777),
            Course(number: 4742),
            Course(number: 4300)
        ]
        req.calculateProgress(NSMutableSet(array: takenCourses), plannedCourses: NSMutableSet())
        XCTAssert(req.takenCS4700)
        XCTAssert(req.takenCS4701)
        XCTAssert(req.takenF78xOrF75x)
        XCTAssert(req.takenF7xxOr4300orF67xor5846)
        XCTAssert(req.takenF74xor4300)
        XCTAssert(req.taken4300orF74xorF75xorF67xorF2xx)
        
        takenCourses = [
            Course(number: 4700),
            Course(number: 4701),
            Course(number: 5752),
            Course(number: 5846),
            Course(number: 4300)
        ]
        
        req.calculateProgress(NSMutableSet(array: takenCourses), plannedCourses: NSMutableSet())
        XCTAssert(req.takenCS4700)
        XCTAssert(req.takenCS4701)
        XCTAssert(req.takenF78xOrF75x)
        XCTAssert(req.takenF7xxOr4300orF67xor5846)
        XCTAssert(req.takenF74xor4300)
        XCTAssert(req.taken4300orF74xorF75xorF67xorF2xx)
    }
    
    func testCSE() {
        let req: CSE = CSE.sharedInstance as! CSE
        var takenCourses: [Course] = [
            Course(number: 4220),
            Course(number: 6210)
        ]
        req.calculateProgress(NSMutableSet(array: takenCourses), plannedCourses: NSMutableSet())
        XCTAssertEqual(req.F2xxFulfilled, 1)
        takenCourses = [
            Course(number: 4220),
            Course(number: 4222)
        ]
        
        req.calculateProgress(NSMutableSet(array: takenCourses), plannedCourses: NSMutableSet())
        XCTAssertEqual(req.F2xxFulfilled, 2)
        takenCourses = [
            Course(number: 6220),
            Course(number: 4222)
        ]
        
        req.calculateProgress(NSMutableSet(array: takenCourses), plannedCourses: NSMutableSet())
        XCTAssertEqual(req.F2xxFulfilled, 2)
        takenCourses = [
            Course(number: 2024),
            Course(number: 2022)
        ]
        
        req.calculateProgress(NSMutableSet(array: takenCourses), plannedCourses: NSMutableSet())
        XCTAssert(req.taken2024)
        XCTAssert(req.taken2022)
    }
    
    func testGraphics() {
        let req: Graphics = Graphics.sharedInstance as! Graphics
        var takenCourses: [Course] = [
            Course(number: 4620),
            Course(number: 4621)
        ]
        req.calculateProgress(NSMutableSet(array: takenCourses), plannedCourses: NSMutableSet())
        XCTAssert(req.taken4620)
        XCTAssert(req.taken4621)
        takenCourses = [
            Course(number: 4222)
        ]
        req.calculateProgress(NSMutableSet(array: takenCourses), plannedCourses: NSMutableSet())
        XCTAssert(req.takenF2xx)
        takenCourses = [
            Course(number: 6620)
        ]
        req.calculateProgress(NSMutableSet(array: takenCourses), plannedCourses: NSMutableSet())
        XCTAssert(req.taken5625or5643or6620or6630or6640or6650)
        XCTAssert(!req.takenF6xxor3152or4152or4154)
        takenCourses.append(Course(number: 4666))
        req.calculateProgress(NSMutableSet(array: takenCourses), plannedCourses: NSMutableSet())
        XCTAssert(req.taken5625or5643or6620or6630or6640or6650)
        XCTAssert(req.takenF6xxor3152or4152or4154)
    }
    
    func testNS() {
        let req: NS = NS.sharedInstance as! NS
        var takenCourses: [Course] = [
            Course(number: 2850),
            Course(number: 4220)
        ]
        req.calculateProgress(NSMutableSet(array: takenCourses), plannedCourses: NSMutableSet())
        XCTAssertEqual(req.x85xor4220Fulfilled, 2)
        takenCourses = [
            Course(number: 4788)
        ]
        req.calculateProgress(NSMutableSet(array: takenCourses), plannedCourses: NSMutableSet())
        XCTAssert(req.takenF78xor4758)
    }
    
    func testPL() {
        let req: PL = PL.sharedInstance as! PL
        var takenCourses: [Course] = [
            Course(number: 4110)
        ]
        req.calculateProgress(NSMutableSet(array: takenCourses), plannedCourses: NSMutableSet())
        XCTAssert(req.takenF110)
        takenCourses.append(Course(number: 4120))
        req.calculateProgress(NSMutableSet(array: takenCourses), plannedCourses: NSMutableSet())
        XCTAssert(req.taken4120)
        takenCourses.append(Course(number: 4121))
        req.calculateProgress(NSMutableSet(array: takenCourses), plannedCourses: NSMutableSet())
        XCTAssert(req.taken4121)
        takenCourses = [
            Course(number: 5114),
            Course(number: 2022)
        ]
        req.calculateProgress(NSMutableSet(array: takenCourses), plannedCourses: NSMutableSet())
        XCTAssert(req.taken4860or5114or5860orF810or6110)
        XCTAssert(req.taken202x)
    }
    
    func testSE() {
        let req: SE = SE.sharedInstance as! SE
        var takenCourses: [Course] = [
            Course(number: 5152),
            Course(number: 4121),
            Course(number: 4321),
            Course(number: 6620)
        ]
        req.calculateProgress(NSMutableSet(array: takenCourses), plannedCourses: NSMutableSet())
        XCTAssert(req.taken5150or5152)
        XCTAssertEqual(req.practicumsFulfilled, 2)
        XCTAssert(req.taken4152or4154orF45xor5300or5412or5414or5625or5643or6620or6630or6650)
        takenCourses = [
            Course(number: 5150),
            Course(number: 4321),
            Course(number: 4321),
            Course(number: 4455)
        ]
        req.calculateProgress(NSMutableSet(array: takenCourses), plannedCourses: NSMutableSet())
        XCTAssert(req.taken5150or5152)
        XCTAssertEqual(req.practicumsFulfilled, 1)
        XCTAssert(req.taken4152or4154orF45xor5300or5412or5414or5625or5643or6620or6630or6650)
    }
    
    func testSD() {
        let req: SD = SD.sharedInstance as! SD
        var takenCourses: [Course] = [
            Course(number: 4411),
            Course(number: 4444),
            Course(number: 4129),
            Course(number: 5320)
        ]
        req.calculateProgress(NSMutableSet(array: takenCourses), plannedCourses: NSMutableSet())
        XCTAssert(req.taken4411)
        XCTAssertEqual(req.F4xxorF12xorF32xor5300Fulfilled, 3)
        takenCourses = [
            Course(number: 4444),
            Course(number: 4320),
            Course(number: 4320)
        ]
        req.calculateProgress(NSMutableSet(array: takenCourses), plannedCourses: NSMutableSet())
        XCTAssertEqual(req.F4xxorF12xorF32xor5300Fulfilled, 2)
        XCTAssert(req.taken4320)
        takenCourses = [
            Course(number: 4411),
            Course(number: 5430),
            Course(number: 5414),
            Course(number: 4320),
            Course(number: 5300)
        ]
        req.calculateProgress(NSMutableSet(array: takenCourses), plannedCourses: NSMutableSet())
        XCTAssert(req.taken4411)
        XCTAssert(req.taken5430)
        XCTAssert(req.taken5412or5414)
        XCTAssert(req.taken4320)
        XCTAssert(req.taken5300)
    }
    
    func testTheory() {
        let req: Theory = Theory.sharedInstance as! Theory
        var takenCourses: [Course] = [
            Course(number: 4811)
        ]
        req.calculateProgress(NSMutableSet(array: takenCourses), plannedCourses: NSMutableSet())
        XCTAssert(req.taken481x)
        takenCourses = [
            Course(number: 6810)
        ]
        req.calculateProgress(NSMutableSet(array: takenCourses), plannedCourses: NSMutableSet())
        XCTAssert(!req.taken481x)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
