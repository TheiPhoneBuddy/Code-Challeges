//
//  MockLogin.swift
//  NameSearchTests
//
//  Created by Francis Chan on 5/17/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

@testable import NameSearch

class MockLoginService:ServicesProtocol  {
    func makeRequest(_ request: Services.Request = Services.Request(),
                     callback: @escaping Services.callback) {
        var response:Services.Response = Services.Response()
        response.user.first = "test first"
        response.user.last = "test last"
        response.token = "123"

        AuthManager.shared.user = response.user
        AuthManager.shared.token = response.token
    }
}
