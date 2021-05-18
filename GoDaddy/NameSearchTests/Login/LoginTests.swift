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

    func testLoginService() {
        viewModel.login("", password: "")
        
        XCTAssertNotNil(AuthManager.shared.user?.first)
        XCTAssertNotNil(AuthManager.shared.user?.last)
        XCTAssertNotNil(AuthManager.shared.token)
    }
}
