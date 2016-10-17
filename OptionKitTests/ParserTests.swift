//
//  ParserTests.swift
//  OptionKitTests
//
//  Created by Blake Merryman on 5/12/16.
//  Copyright © 2016 Blake Merryman. All rights reserved.
//

import XCTest
@testable import OptionKit

class ParserTests: XCTestCase {
    
    // MARK: - Test Data
    
    fileprivate enum TestInput {
        static let A = ["/path/to/file.swift","--optA","argument"]
        static let B = ["/path/to/file.swift", "--optA", "one", "two", "three", "--optB", "four", "five", "six"]
        static let C = ["/path/to/file.swift", "--optA", "--optB", "four", "five", "six"]
    }
    
    fileprivate enum TestOption {
        static let A = Option(longFlag: "--optA", shortFlag: "-a", completionHandler: nil)
        static let B = Option(longFlag: "--optB", shortFlag: "-b", completionHandler: nil)
    }
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        // Put setup code here. 
        // This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDown() {
        
        // Put teardown code here.
        // This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Test Methods
    
    func testParseTestInputA() {
        
        guard let results = Parser.parseProcessArguments(TestInput.A, againstOptions: [ TestOption.A ] ) else {
            return XCTFail()
        }
        
        guard let result = results.first , results.count == 1 else {
            return XCTFail()
        }
        
        XCTAssert(result.option == TestOption.A)
        
        guard let argument = result.arguments?.first , result.arguments!.count == 1 else {
            return XCTFail()
        }
        
        XCTAssert(argument == "argument")
        
    }
    
    func testParseTestInputB() {
        
        guard let results = Parser.parseProcessArguments(TestInput.B, againstOptions: [ TestOption.A, TestOption.B ])
            , results.count == 2 else {
                return XCTFail()
        }
        
        let resultA = results[0]
        let resultB = results[1]
        
        XCTAssert( resultA.option == TestOption.A )
        XCTAssert( resultB.option == TestOption.B )
        
        guard let argumentsA = resultA.arguments, let argumentsB = resultB.arguments else {
            return XCTFail()
        }
        
        XCTAssert( argumentsA == ["one", "two", "three"] )
        XCTAssert( argumentsB == ["four", "five", "six"] )
    }
    
    func testParseTestInputC() {
        
        guard let results = Parser.parseProcessArguments(TestInput.C, againstOptions: [ TestOption.A, TestOption.B ])
            , results.count == 2 else {
                return XCTFail()
        }
        
        let resultA = results[0]
        let resultB = results[1]
        
        XCTAssert( resultA.option == TestOption.A )
        XCTAssert( resultB.option == TestOption.B )
        
        guard let argumentsA = resultA.arguments, let argumentsB = resultB.arguments else {
            return XCTFail()
        }
        
        XCTAssert( argumentsA.isEmpty )
        XCTAssert( argumentsB == ["four", "five", "six"] )
    }
    
}
