//
//  CartViewModel.swift
//  NameSearch
//
//  Created by Francis Chan on 5/18/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import Foundation

protocol CartViewModelDelegate:class {
    func didMakeRequestSuccess()
    func didMakeRequestFailed(_ errorMsg:String)
}

class CartViewModel {
    var response:Services.Response = Services.Response()
    
    weak var delegate: CartViewModelDelegate?
    
    let services: ServicesProtocol
    init(service: ServicesProtocol = Services()) {
        self.services = service
    }

    func shoppingCart(_ auth:String,
                      token:String) {
        var request:Services.Request = Services.Request()
        request.endPoint = .ShoppingCart
        request.urlString = "https://gd.proxied.io/payments/process"
        request.httpMethod = "POST"
        request.auth = auth
        request.token = token

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
    
    func getPayButtonText() -> String {
        var msg:String = ""
        if PaymentsManager.shared.selectedPaymentMethod == nil {
            msg = "Select a Payment Method"
        } else {
            var totalPayment = 0.00

            ShoppingCart.shared.domains.forEach {
                let priceDouble:Double? = Double($0.price.replacingOccurrences(of: "$", with: ""))
                totalPayment += priceDouble ?? 0.0
            }

            let currencyFormatter = NumberFormatter()
            currencyFormatter.numberStyle = .currency

            msg = "Pay \(currencyFormatter.string(from: NSNumber(value: totalPayment))!) Now"
        }
        
        return msg
    }
}
