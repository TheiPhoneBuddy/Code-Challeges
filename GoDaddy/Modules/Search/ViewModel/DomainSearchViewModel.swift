//
//  DomainSearchViewModel.swift
//  NameSearchTests
//
//  Created by Francis Chan on 5/17/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

protocol DomainSearchViewModelDelegate:class {
    func didMakeRequestSuccess()
    func didMakeRequestFailed(_ errorMsg:String)
}

class DomainSearchViewModel {
    var response:Services.Response = Services.Response()
    weak var delegate: DomainSearchViewModelDelegate?
    
    let services: ServicesProtocol
    init(service: ServicesProtocol = Services()) {
        self.services = service
    }

    func getData(_ searchTerms:String) {
        var request:Services.Request = Services.Request()
        request.endPoint = .Search
        request.urlString = "https://gd.proxied.io/search/"
        request.httpMethod = "GET"
        request.searchTerms = searchTerms

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
