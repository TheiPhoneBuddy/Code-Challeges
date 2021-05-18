//
//  ServicesTests.swift
//  NameSearchTests
//
//  Created by Francis Chan on 5/18/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

@testable import NameSearch
import XCTest

class ServicesTests: XCTestCase {
    //Happy Path(s)
    func testGetLoginData() {
        var request:Services.Request = Services.Request()
        request.endPoint = .Login
        //Read from "Login.json"
        request.urlString = Utils.getPathToFile("Login")
        request.httpMethod = "POST"
        request.username = "test username"
        request.password = "test password"
        
        let services:Services = Services()
        services.makeRequest(request,
            callback:{(response:Services.Response) -> Void in
               
            DispatchQueue.main.async {
                //Assuming if there are no errors you should get a token.
                XCTAssertNotEqual(response.token, "")
                XCTAssertNotEqual(response.errorMsg, nil)
            }
        })
    }
    
    func testPayment() {
        var request:Services.Request = Services.Request()
        request.endPoint = .Payment
        //Read from "Payment.json"
        request.urlString = Utils.getPathToFile("Payment")
        request.httpMethod = "POST"
        
        let services:Services = Services()
        services.makeRequest(request,
            callback:{(response:Services.Response) -> Void in
                
            DispatchQueue.main.async {
                //If errorMsg is nil assume things are ok.
                XCTAssertNil(response.errorMsg)
            }
        })
    }
    
    func testErrorEndPointNotSpecified() {
        var request:Services.Request = Services.Request()
        //Read from "Login.json"
        request.urlString = Utils.getPathToFile("Login")
        request.httpMethod = "POST"
        request.username = "test username"
        request.password = "test password"
        
        let services:Services = Services()
        services.makeRequest(request,
            callback:{(response:Services.Response) -> Void in
                
            DispatchQueue.main.async {
                //No endpoint specified.
                XCTAssertNotNil(response.errorMsg)
            }
        })
    }
}
