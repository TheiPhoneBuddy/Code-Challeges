//
//  LoginTests.swift
//  NameSearchTests
//
//  Created by Francis Chan on 5/17/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

@testable import NameSearch
import XCTest

class LoginTests: XCTestCase {
    //Happy Path
    func testLoginService() {
        let mock:MockLoginService = MockLoginService()
        var viewModel:LoginViewModel = LoginViewModel()
        viewModel = .init(service: mock)
        viewModel.login("test user", password: "test password")
        
        XCTAssertNotEqual(viewModel.response.user.first, "")
        XCTAssertNotEqual(viewModel.response.user.last, "")
        XCTAssertNotEqual(viewModel.response.token, "")
        XCTAssertEqual(viewModel.response.errorMsg, nil)
     }
    
    func testInvalidToken() {
        let mock:MockLoginInvalidToken = MockLoginInvalidToken()
        var viewModel:LoginViewModel = LoginViewModel()
        viewModel = .init(service: mock)
        viewModel.login("test user", password: "test password")

        //token is blank
        XCTAssertEqual(viewModel.response.token, "")
    }
}
