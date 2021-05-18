//
//  MockShoppingCartService.swift
//  NameSearchTests
//
//  Created by Francis Chan on 5/18/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

@testable import NameSearch

class MockShoppingCartService:ServicesProtocol  {
    func makeRequest(_ request: Services.Request = Services.Request(),
                     callback: @escaping Services.callback) {
        var response:Services.Response = Services.Response()
        response.errorMsg = nil
        callback(response)
    }
}
