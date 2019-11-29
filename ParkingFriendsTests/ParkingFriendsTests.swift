//
//  ParkingFriendsTests.swift
//  ParkingFriendsTests
//
//  Created by misco on 2019/10/14.
//  Copyright © 2019 Hancom Mobility. All rights reserved.
//

import XCTest
@testable import ParkingFriends

class ParkingFriendsTests: XCTestCase {

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
}

extension ParkingFriendsTests {
    func testAuth() {
   //     let result = expectation(description: "Login Request")
        
        Auth.login(username: "01012341234", password: "passw0rd") { [weak self] (login, message) in
                   print("[R]", login.debugDescription)
                   if let _ = message {
                    //   result.fulfill()
                   } else {
                    //   self!.updateStatus(.verified)
                   }
               }
        
    }
}
