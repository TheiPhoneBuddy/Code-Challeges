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
    }

    //Response
    struct Response {
        var errorMsg:String?
        var user:User = User()
        var token:String = ""
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
        let task = session.dataTask(with: loginRequest) { (data, response, error) in
            guard error == nil else {
                self.response.errorMsg = error?.localizedDescription
                self.callback!(self.response)
                return
            }

            let authReponse = try! JSONDecoder().decode(LoginResponse.self, from: data!)
            
            self.response.user = authReponse.user
            self.response.token = authReponse.auth.token
            
            self.callback!(self.response)
        }
        task.resume()
    }
    
    //search
    fileprivate func search() {
        self.callback!(Response())
    }

    //payment
    fileprivate func payment() {
        self.callback!(Response())
    }
}
