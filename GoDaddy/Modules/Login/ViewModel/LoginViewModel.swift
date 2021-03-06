//
//  LoginViewModel.swift
//  NameSearch
//
//  Created by Francis Chan on 5/17/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import Foundation

protocol LoginViewModelDelegate:class {
    func didMakeRequestSuccess()
    func didMakeRequestFailed(_ errorMsg:String)
}

class LoginViewModel {
    var response:Services.Response = Services.Response()
    
    weak var delegate: LoginViewModelDelegate?
    
    let services: ServicesProtocol
    init(service: ServicesProtocol = Services()) {
        self.services = service
    }

    func login(_ username:String,
               password:String) {
        var request:Services.Request = Services.Request()
        request.endPoint = .Login
        request.urlString = "https://gd.proxied.io/auth/login"
        request.httpMethod = "POST"
        request.username = username
        request.password = password

        weak var weakSelf = self
        services.makeRequest(request,
            callback:{(response:Services.Response) -> Void in
            if response.errorMsg == nil {
                weakSelf?.response = response
                
                AuthManager.shared.user = response.user
                AuthManager.shared.token = response.token

                weakSelf?.delegate?.didMakeRequestSuccess()
             }else{
                weakSelf?.delegate?.didMakeRequestFailed(response.errorMsg ?? "")
            }
        })
    }
}
