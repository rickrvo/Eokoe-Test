//
//  Teste_EokoeTests.swift
//  Teste-EokoeTests
//
//  Created by Rick on 11/12/18.
//  Copyright © 2018 Rick. All rights reserved.
//

import XCTest
@testable import Teste_Eokoe

class Teste_EokoeTests: XCTestCase {
    
    var sessionUnderTest: URLSession!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sessionUnderTest = URLSession(configuration: URLSessionConfiguration.default)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sessionUnderTest = nil
        super.tearDown()
    }


    func testValidCallToServerGetsHTTPStatusCode200() {
        // given
        let url = URL(string: "http://testmobiledev.eokoe.com/users?start=0&limit=90")
        let request = NSMutableURLRequest(url: url!)
        request.setValue("d4735e3a265e16eee03f59718b9b5d03019c07d8b6c51f90da3a666eec13ab35", forHTTPHeaderField: "X-API-Key")
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 1
        let promise = expectation(description: "Status code: 200")
        var statusCode: Int?
        var responseError: Error?
        
        self.measure {
            let dataTask = sessionUnderTest.dataTask(with: request as URLRequest, completionHandler: { (receivedData, response, err) -> Void in
                // then
                statusCode = (response as? HTTPURLResponse)?.statusCode
                responseError = err
                
                promise.fulfill()
            })
            dataTask.resume()

        }
        
        // 3
        waitForExpectations(timeout: 5, handler: nil)
        
        // then
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }

}
