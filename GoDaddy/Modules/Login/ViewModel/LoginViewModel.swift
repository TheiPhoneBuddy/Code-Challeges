//
//  LoginViewModel.swift
//  NameSearch
//
//  Created by Francis Chan on 5/17/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import Foundation

//LoginViewModelDelegate
protocol LoginViewModelDelegate:class {
    func didMakeRequestSuccess()
    func didMakeRequestFailed(_ errorMsg:String)
}

//LoginViewModel
class LoginViewModel {
    //delegate
    weak var delegate: LoginViewModelDelegate?
    
    //ServicesProtocol
    let services: ServicesProtocol
    init(service: ServicesProtocol = Services()) {
        self.services = service
    }

    //login
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
                AuthManager.shared.user = response.user
                AuthManager.shared.token = response.token

                //didMakeRequestSuccess
                weakSelf?.delegate?.didMakeRequestSuccess()
             }else{
                //didMakeRequestFailed
                weakSelf?.delegate?.didMakeRequestFailed(response.errorMsg ?? "")
            }
        })
    }
}
