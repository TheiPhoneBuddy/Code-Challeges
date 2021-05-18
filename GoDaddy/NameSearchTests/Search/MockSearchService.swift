//
//  MockSearchService.swift
//  NameSearchTests
//
//  Created by Francis Chan on 5/18/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

@testable import NameSearch
class MockSearchService:ServicesProtocol  {
    func makeRequest(_ request: Services.Request = Services.Request(),
                     callback: @escaping Services.callback) {
        
        var response:Services.Response = Services.Response()
        let domain:Domain = Domain(name: "test name", price: "test price", productId: 1)
        response.aryData = [domain]

        callback(response)
    }
}
