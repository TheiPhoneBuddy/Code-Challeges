//
//  ShoppingCartTests.swift
//  NameSearchTests
//
//  Created by Francis Chan on 5/18/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

@testable import NameSearch
import XCTest

class ShoppingCartTests: XCTestCase {
    var mock:MockShoppingCartService = MockShoppingCartService()
    var viewModel:CartViewModel = CartViewModel()
    
    override func setUp() {
        viewModel = .init(service: mock)
    }

    //Happy Path
    func testLoginService() {
        viewModel.shoppingCart("test auth", token: "test token")

        //Success no error msg.
        XCTAssertNil(viewModel.response.errorMsg)
    }
}
