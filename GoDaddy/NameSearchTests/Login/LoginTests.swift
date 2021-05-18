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
    var mock:MockLoginService = MockLoginService()
    var viewModel:LoginViewModel = LoginViewModel()
    
    override func setUp() {
        viewModel = .init(service: mock)
    }

    //Happy Path
    func testLoginService() {
        viewModel.login("", password: "")
        
        XCTAssertNotNil(viewModel.response.user.first)
        XCTAssertNotNil(viewModel.response.user.last)
        XCTAssertNotNil(viewModel.response.token)
    }
}
