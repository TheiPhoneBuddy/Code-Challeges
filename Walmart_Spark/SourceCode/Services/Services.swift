//
//  Services.swift
//  Walmart_Spark
//
//  Created by Francis Chan on 1/8/21.
//

import Foundation

protocol ServicesDelegate:class {
    func didMakeRequestFailed(_ errorMsg:String)
}

class Services:NSObject {
    //EndPoint
    enum EndPoint:Int {
        case TopMovies
        case Genres
        case Photos
    }
    
    //Request
    struct Request {
        var endPoint:EndPoint
        var urlString:String
        
        init() {
            self.endPoint = EndPoint.TopMovies
            self.urlString = ""
        }
    }

    //Response
    struct Response {
        var dataModel:DataModel
        var genreDataModel:GenreDataModel
        var data:Data
        var errorMsg:String

        init() {
            self.dataModel = DataModel()
            self.genreDataModel = GenreDataModel()
            self.data = Data()
            self.errorMsg = ""
        }
    }

    //Public
    typealias callback = (Response) -> Void
    weak var delegate: ServicesDelegate?
    
    //Private
    fileprivate var callback:Services.callback?
    fileprivate var request:Services.Request = Services.Request()
    fileprivate var response:Services.Response = Services.Response()

    //makeRequest
    public static func makeRequest(_ request:Request,
                                   callback:@escaping Services.callback) {
        let obj:Services = Services()
            obj.callback = callback
            obj.request = request
            obj.makeRequest(request,
                callback:{(resp:Response) -> Void in
                callback(resp)
        })
    }

    fileprivate func makeRequest(_ request:Request,
                    callback:@escaping Services.callback) -> Void {
        
        let config:URLSessionConfiguration = URLSessionConfiguration.default
        let session:URLSession = URLSession(configuration: config)
        
        weak var weakSelf = self
        if let url = URL(string: request.urlString) {
           let task = session.dataTask(with: url,
                      completionHandler:{
                       [executeCallback]
            (data, resp, error) in
                if error == nil {
                    if request.endPoint == EndPoint.TopMovies {
                        weakSelf?.response.dataModel = Utils.decode(data ?? Data()) as DataModel
                    } else if request.endPoint == EndPoint.Genres  {
                        weakSelf?.response.genreDataModel = Utils.decode(data ?? Data()) as GenreDataModel
                    } else {
                        //Photos
                        weakSelf?.response.data = data ?? Data()
                    }
                } else {
                    weakSelf?.response.errorMsg = error?.localizedDescription ?? "Error"
                }
                executeCallback()
            })
            task.resume()
        } else {
            response.errorMsg = "Invalid url."
            executeCallback()
        }
    }

    //executeCallback
    fileprivate func executeCallback() {
        if let callback = self.callback {
           callback(self.response)
        }else{
           delegate?.didMakeRequestFailed("'callback()' is nil.")
        }
    }
}
