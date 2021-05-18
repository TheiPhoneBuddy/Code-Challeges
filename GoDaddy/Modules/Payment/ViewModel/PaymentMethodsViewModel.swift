//
//  PaymentMethodsViewModel.swift
//  NameSearchTests
//
//  Created by Francis Chan on 5/18/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import Foundation

protocol PaymentMethodsViewModelDelegate:class {
    func didMakeRequestSuccess()
    func didMakeRequestFailed(_ errorMsg:String)
}

class PaymentMethodsViewModel {
    var response:Services.Response = Services.Response()
    weak var delegate: PaymentMethodsViewModelDelegate?

    let services: ServicesProtocol
    init(service: ServicesProtocol = Services()) {
        self.services = service
    }

    func getData() {
        var request:Services.Request = Services.Request()
        request.endPoint = .Payment
        request.urlString = "https://gd.proxied.io/user/payment-methods"
        request.httpMethod = "GET"

        weak var weakSelf = self
        services.makeRequest(request,
            callback:{(response:Services.Response) -> Void in
            if response.errorMsg == nil {
                weakSelf?.response = response
                weakSelf?.delegate?.didMakeRequestSuccess()
             }else{
                weakSelf?.delegate?.didMakeRequestFailed(response.errorMsg ?? "")
            }
        })
    }
}
