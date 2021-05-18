//
//  MockPaymentService.swift
//  NameSearchTests
//
//  Created by Francis Chan on 5/18/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

@testable import NameSearch
class MockPaymentService:ServicesProtocol  {
    func makeRequest(_ request: Services.Request = Services.Request(),
                     callback: @escaping Services.callback) {
        
        var response:Services.Response = Services.Response()
        
        let payment:PaymentMethod = PaymentMethod(name: "test name",token: "123")
        response.aryPaymentMethod = [payment]

        callback(response)
    }
}
