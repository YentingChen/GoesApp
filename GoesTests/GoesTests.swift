//
//  GoesTests.swift
//  GoesTests
//
//  Created by Yenting Chen on 2019/5/10.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import XCTest
import Firebase

class GoesTests: XCTestCase {
    
    var results = [Int]()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


    func fab(nnn: Int) -> Int? {
//        if nnn <= 1 {
//            return 1
//        }
        
        if nnn < 0 {
            return nil
        }
        
        for iii in 0...nnn {
            if iii <= 1 {
                
                results.append(1)
                
            } else {
                
                let first = results[iii-2]
                let second = results[iii-1]
                
                results.append(first+second)
                
            }
            
        }
        
        return results[nnn]
        
    }
    
//    func test_getData_fail() {}
//    test method 用底線
    
    func testtestlab() {
       XCTAssertTrue(fab(nnn: -1 ) == nil)
    }
    
//
//    func fib(n: Int) -> Int {
//
//        if n == 0 {
//
//            return 0
//
//        } else if n == 1 {
//
//            return 1
//
//        } else {
//
//            return fib(n: n-1) + fib(n: n-2)
//
//        }
//    }
    
    func testLuke() {
        //3A - Arrange, Action, Assert
        
        //Arrange
        let aaa = 10
        
        let bbb = 20
        
        let expectedResult = aaa + bbb
        
        //Action
        let actualResult = add(aaa: aaa, bbb: bbb)
        
        //Assert
        XCTAssertEqual(actualResult, expectedResult)
       
    }
    
    

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            
            for _ in 0...1000 {
                let _ = UIView()
            }
        }
    }

}
