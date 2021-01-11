//
//  Configurations.swift
//  Walmart_Spark
//
//  Created by Francis Chan on 1/8/21.
//

import Foundation

class Configurations:NSObject {
    static let key:String = "2a61185ef6a27f400fd92820ad9e8537"
    static let baseURL:String = "https://api.themoviedb.org/3/discover/movie?api_key="
    static var photoUrl:String = "https://image.tmdb.org/t/p/w200"
    static var genreUrl:String = "https://api.themoviedb.org/3/genre/movie/list?api_key="
    static var movieUrl:String = "https://api.themoviedb.org/3/movie/"
    
    //topMoviesURL
    static func topMoviesURL() -> String {
        return baseURL + key
    }
    
    //genreURL
    static func genreURL() -> String {
        return genreUrl + key
    }
    
    //movieURL
    static func movieURL(_ id:Int) -> String {
        return movieUrl + String(id) + "?api_key=" + key
    }
}
