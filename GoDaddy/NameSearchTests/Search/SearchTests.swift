//
//  SearchTests.swift
//  NameSearchTests
//
//  Created by Francis Chan on 5/18/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

@testable import NameSearch
import XCTest

class SearchTests: XCTestCase {
    var mock:MockSearchService = MockSearchService()
    var viewModel:DomainSearchViewModel = DomainSearchViewModel()
    
    override func setUp() {
        viewModel = .init(service: mock)
    }

    //Happy Path
    func testGetData() {
        viewModel.getData("test search term")
        
        XCTAssertNotNil(viewModel.response.aryData[0].name)
        XCTAssertNotNil(viewModel.response.aryData[0].price)
        XCTAssertNotNil(viewModel.response.aryData[0].productId)
    }
}
