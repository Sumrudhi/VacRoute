//
//  VacCalcTests.swift
//  VacCalcTests
//
//  Created by Sumrudhi Jadhav on 11/21/20.
//  Copyright © 2020 CATS. All rights reserved.
//

import XCTest
@testable import VacCalc

class VacCalcTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    // MARK: Hospital Class Tests
    // Confirm that the Hospital initializer returns a Hospital object when passed valid parameters
    func testHospitalInitializationSucceeds(){
        
    }
    
    // Confirm that the Hospital initialsier returns niil when passed a negative rating or an empty name
    func testHospitalInitalizationFails() {
        //Empty Strings
        let emptyStringHospital = Hospital.init(name: "", inStock: "", needed: "", photo: nil)
        XCTAssertNil(emptyStringHospital)
    }
    
}
