//
//  PaymentTests.swift
//  NameSearchTests
//
//  Created by Francis Chan on 5/18/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

@testable import NameSearch
import XCTest

class PaymentTests: XCTestCase {

    var mock:MockPaymentService = MockPaymentService()
    var viewModel:PaymentMethodsViewModel = PaymentMethodsViewModel()
    
    override func setUp() {
        viewModel = .init(service: mock)
    }

    //Happy Path
    func testGetData() {
        viewModel.getData()
        
        XCTAssertNotNil(viewModel.response.aryPaymentMethod[0].name)
        XCTAssertNotNil(viewModel.response.aryPaymentMethod[0].token)
    }
}
