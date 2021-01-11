//
//  Services.swift
//  Walmart_Spark
//
//  Created by Francis Chan on 1/8/21.
//

import Foundation
import HTTPManager

protocol ServicesDelegate:class {
    func didMakeRequestFailed(_ errorMsg:String)
}

class Services:NSObject {
    //EndPoint
    enum EndPoint:Int {
        case TopMovies
        case Genres
        case Photos
        case Movie
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
        var movieDataModel:MovieDataModel
        var dictPhotos:[String:Any]

        var data:Data
        var errorMsg:String

        init() {
            self.dataModel = DataModel()
            self.genreDataModel = GenreDataModel()
            self.movieDataModel = MovieDataModel()
            self.dictPhotos = [:]
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
                       [getImages,executeCallback]
            (data, resp, error) in
                if error == nil {
                    if request.endPoint == EndPoint.TopMovies {
                        weakSelf?.response.dataModel = Utils.decode(data ?? Data()) as DataModel
                        getImages()
                    } else if request.endPoint == EndPoint.Genres  {
                        weakSelf?.response.genreDataModel = Utils.decode(data ?? Data()) as GenreDataModel
                        executeCallback()
                    } else if request.endPoint == EndPoint.Movie  {
                        weakSelf?.response.movieDataModel = Utils.decode(data ?? Data()) as MovieDataModel
                        executeCallback()
                    } else {
                        //Photos
                        weakSelf?.response.data = data ?? Data()
                        executeCallback()
                    }
                } else {
                    weakSelf?.response.errorMsg = error?.localizedDescription ?? "Error"
                    executeCallback()
                }
            })
            task.resume()
        } else {
            response.errorMsg = "Invalid url."
            executeCallback()
        }
    }

    //getImages
    fileprivate func getImages(){
        var aryRequests:[[String:Any]] = []
        for result in response.dataModel.results {
            if result.poster_path != "" {
                let urlString:String = Configurations.photoUrl  + result.poster_path
                let dict: [String: String] = ["urlString":urlString,
                                              "requestID":result.poster_path]
                aryRequests.append(dict)
            }
        }
        
        let request: Dictionary<String,Any> = ["aryRequests":aryRequests,
                                               "requestPerBatch":10]
        weak var weakSelf = self
        HTTPManager.makeRequests(request,callback:{[executeCallback](resp:Dictionary<String,Any>?,
            errorMsg:String?) -> Void in
            if(errorMsg != nil){
               #if DEBUG
               print(errorMsg ?? "")
               #endif
            }else{
               if let resp = resp?["data"] {
                  weakSelf?.response.dictPhotos = resp as? Dictionary<String,Any> ?? [:]
               }
                
               #if DEBUG
               if let resp = resp?["time"] {
                  let time:String = resp as? String ?? ""
                print("\n\n",
                      weakSelf?.response.dictPhotos.count ?? 0 ,
                      " images downloaded in:",time,"secs.\n\n")
               }
               #endif
            }
            executeCallback()
        })
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
