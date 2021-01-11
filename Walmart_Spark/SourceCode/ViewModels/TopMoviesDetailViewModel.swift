//
//  TopMoviesDetailViewModel.swift
//  Walmart_Spark
//
//  Created by Francis Chan on 1/8/21.
//

import Foundation

protocol TopMoviesDetailViewModelDelegate:class {
    func didMakeRequestSuccess(_ homepage:String)
    func didMakeRequestFailed(_ errorMsg:String)
}

class TopMoviesDetailViewModel:NSObject {
    public weak var delegate: TopMoviesDetailViewModelDelegate?

    //getMovie
    func getMovie(_ id:Int){
        var request:Services.Request = Services.Request()
        request.endPoint = Services.EndPoint.Movie
        request.urlString = Configurations.movieURL(id)
        
        weak var weakSelf = self
        Services.makeRequest(request,
            callback:{(response:Services.Response) -> Void in
            if response.errorMsg == "" {
                weakSelf?.delegate?.didMakeRequestSuccess(response.movieDataModel.homepage)
            }else{
                weakSelf?.delegate?.didMakeRequestFailed(response.errorMsg)
            }
        })
    }

    func titleString(_ str:String) -> String {
        return "Title: " + str
    }

    func overview(_ str:String) -> String {
        return str
    }

    func release_date(_ str:String) -> String {
        return "Release Date: " + str
    }

    func original_language(_ str:String) -> String {
        return "Original Language: " + str
    }

    func popularity(_ value:Double) -> String {
        return "Popularity: " + String(value)
    }

    func vote_average(_ value:Double) -> String {
        return "Vote Average: " + String(value)
    }

    func vote_count(_ value:Int) -> String {
        return "Vote Count: " + String(value)
    }

    func id(_ value:Int) -> String {
        return "id: " + String(value)
    }

    func genre_names(_ str:String) -> String {
        return "genres: " + String(str)
    }

    func poster_path_image(_ data:Data) -> Data {
        return data
    }
}
