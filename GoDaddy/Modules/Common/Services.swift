//
//  Services.swift
//  NameSearch
//
//  Created by Francis Chan on 5/17/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import Foundation

class Services:ServicesProtocol {
    //EndPoint
    enum EndPoint:Int {
        case None
        case Login
        case Search
        case Payment
    }
    
    //Request
    struct Request {
        var endPoint:EndPoint = .None
        var httpMethod:String = ""
        var urlString:String = ""
        var username:String = ""
        var password:String = ""
        var searchTerms:String = ""
    }

    //Response
    struct Response {
        var errorMsg:String?
        var user:User = User()
        var token:String = ""
        var aryData:[Domain] = []
        var aryPaymentMethod:[PaymentMethod] = []
    }

    //callback
    typealias callback = (Response) -> Void

    //Private
    fileprivate var callback:Services.callback?
    fileprivate var request:Services.Request = Services.Request()
    fileprivate var response:Services.Response = Services.Response()

    //makeRequest
    public func makeRequest(_ request:Request,
                            callback:@escaping Services.callback) {
        self.callback = callback
        self.request = request

        switch request.endPoint {
        case .Login:
            login()
        case .Search:
            search()
        case .Payment:
            payment()
            
        default:
            response.errorMsg = "Invalid endpoint."
            callback(response)
        }
    }
    
    //login
    fileprivate func login() {
        var loginRequest = URLRequest(url: URL(string:self.request.urlString)!)
        loginRequest.httpMethod = self.request.httpMethod

        let dict: [String: String] = [
            "username": self.request.username,
            "password": self.request.password
        ]

        loginRequest.httpBody = try! JSONSerialization.data(withJSONObject: dict,
                                                       options: .fragmentsAllowed)
        
        let session = URLSession(configuration: .default)
        weak var weakSelf = self
        let task = session.dataTask(with: loginRequest) { (data, response, error) in
            guard error == nil else {
                weakSelf?.response.errorMsg = error?.localizedDescription
                weakSelf?.callback!(self.response)
                return
            }

            let authReponse = try! JSONDecoder().decode(LoginResponse.self, from: data!)
            
            weakSelf?.response.user = authReponse.user
            weakSelf?.response.token = authReponse.auth.token
            
            weakSelf?.callback!(self.response)
        }
        task.resume()
    }

    //search
    fileprivate func search() {
        let searchTerms = request.searchTerms
        let session = URLSession(configuration: .default)

        //"https://gd.proxied.io/search/exact
        var urlComponents = URLComponents(string: self.request.urlString + "exact")!
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: searchTerms)
        ]

        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = self.request.httpMethod

        let urlString:String = self.request.urlString
        
        weak var weakSelf = self
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                weakSelf?.response.errorMsg = error?.localizedDescription
                weakSelf?.callback!(self.response)
                return
            }

            if let data = data {
                let exactMatchResponse = try! JSONDecoder().decode(DomainSearchExactMatchResponse.self, from: data)

                //https://gd.proxied.io/search/spins
                var suggestionsComponents = URLComponents(string: urlString + "spins")!
                suggestionsComponents.queryItems = [
                    URLQueryItem(name: "q", value: searchTerms)
                ]

                var suggestionsRequest = URLRequest(url: suggestionsComponents.url!)
                suggestionsRequest.httpMethod = "GET"

                let suggestionsTask = session.dataTask(with: suggestionsRequest) { (suggestionsData, suggestionsResponse, suggestionsError) in
                    guard error == nil else {
                        weakSelf?.response.errorMsg = error?.localizedDescription
                        weakSelf?.callback!(self.response)
                        return
                    }

                    if let suggestionsData = suggestionsData {
                        let suggestionsResponse = try! JSONDecoder().decode(DomainSearchRecommendedResponse.self, from: suggestionsData)

                        let exactDomainPriceInfo = exactMatchResponse.products.first(where: { $0.productId == exactMatchResponse.domain.productId })!.priceInfo
                        let exactDomain = Domain(name: exactMatchResponse.domain.fqdn,
                                                 price: exactDomainPriceInfo.currentPriceDisplay,
                                                 productId: exactMatchResponse.domain.productId)

                        let suggestionDomains = suggestionsResponse.domains.map { domain -> Domain in
                            let priceInfo = suggestionsResponse.products.first(where: { price in
                                price.productId == domain.productId
                            })!.priceInfo

                            return Domain(name: domain.fqdn, price: priceInfo.currentPriceDisplay, productId: domain.productId)
                        }
                        
                        weakSelf?.response.aryData = [exactDomain] + suggestionDomains
                        weakSelf?.callback!(weakSelf?.response ?? Services.Response())
                    }
                }
                suggestionsTask.resume()
            }
        }
        task.resume()
    }

    //payment
    fileprivate func payment() {
        //"https://gd.proxied.io/user/payment-methods"
        let request = URLRequest(url: URL(string: self.request.urlString)!)
        let session = URLSession(configuration: .default)
        
        weak var weakSelf = self
        let task = session.dataTask(with: request) {
            (data,response,error) in
            guard error == nil else {
                weakSelf?.response.errorMsg = error?.localizedDescription
                weakSelf?.callback!(self.response)
                return
            }

            weakSelf?.response.aryPaymentMethod = try!
                JSONDecoder().decode([PaymentMethod].self, from: data ?? Data())

            weakSelf?.callback!(self.response)
        }
        task.resume()
    }
}
