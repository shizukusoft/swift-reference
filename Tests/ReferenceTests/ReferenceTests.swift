//
//  ReferenceTests.swift
//  
//
//  Created by Jaehong Kang on 2023/02/18.
//

import XCTest
@testable import Reference

final class ReferenceTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let iteration = 100
        let reference = Reference(0)

        DispatchQueue.concurrentPerform(iterations: iteration) { _ in
            reference.modify { value in
                value += 1
            }
        }

        XCTAssertEqual(reference.wrappedValue, iteration)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
