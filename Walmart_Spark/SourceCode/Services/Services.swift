//
//  Services.swift
//  Walmart_Spark
//
//  Created by Francis Chan on 1/8/21.
//

import Foundation

protocol ServicesDelegate:class {
    func didMakeRequestSuccess(_ dataModel:DataModel)
    func didGetGenreSuccess(_ genreDataModel:GenreDataModel)
    func didMakeRequestFailed(_ errorMsg:String)
}

class Services:NSObject {
    public weak var delegate: ServicesDelegate?

    //getTopMovies
    func getTopMovies(_ page:Int = 1){
        let urlString:String = Configurations.topMoviesURL()
        let request: String = urlString + "&page=" + String(page)
        
        #if DEBUG
        print("\n\n",request,"\n\n")
        #endif
        
        getData(request:request) {[parseTopMoviesData](data) in
            parseTopMoviesData(data)
        }
    }

    //getGenres
    func getGenres(){
        let urlString:String = Configurations.genreURL()        
        let request: String = urlString
        getData(request:request) {[parseGenreData](data) in
            parseGenreData(data)
        }
    }
    
    //getImage
    func getImage(_ url:String,
                  completion: @escaping(_ data:Data) -> Void) {
        let config:URLSessionConfiguration = URLSessionConfiguration.default
        let session:URLSession = URLSession(configuration: config)
        
        weak var weakSelf = self
        if let url = URL(string: url) {
            let task = session.dataTask(with: url, completionHandler:{
            (data, response, error) in
                if error != nil {
                    weakSelf?.delegate?.didMakeRequestFailed(error?.localizedDescription ?? "Error")
                } else {
                    completion(data ?? Data())
                }
            })
            task.resume()
        } else {
            delegate?.didMakeRequestFailed("URL error.")
        }
    }
    
    //parseGenreData
    fileprivate func parseGenreData(_ data:Data) {
        do {
            let decoder = JSONDecoder()
            let genreDataModel:GenreDataModel? = try decoder.decode(GenreDataModel.self,
                                                          from:data)
                if let genreDataModel = genreDataModel {
                   delegate?.didGetGenreSuccess(genreDataModel)
                } else {
                   delegate?.didMakeRequestFailed("Invalid json!")
                }
        } catch {
            delegate?.didMakeRequestFailed("Parse error!")
        }
    }

    //parseData
    fileprivate func parseTopMoviesData(_ data:Data) {
        do {
            let decoder = JSONDecoder()
            let dataModel:DataModel? = try decoder.decode(DataModel.self,
                                                          from:data)
                if let dataModel = dataModel {
                   delegate?.didMakeRequestSuccess(dataModel)
                } else {
                   delegate?.didMakeRequestFailed("Invalid json!")
                }
        } catch {
            delegate?.didMakeRequestFailed("Parse error!")
        }
    }
    
    //getData
    fileprivate func getData(request:String, completion: @escaping(_ data:Data) -> Void) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        if let url:URL = URL(string: request) {
            weak var weakSelf = self
            let task = session.dataTask(with: url, completionHandler:{
                (data, response, error) in
                if error != nil {
                   weakSelf?.delegate?.didMakeRequestFailed(error?.localizedDescription ?? "Error")
                } else {
                    completion(data ?? Data())
                }
            })
            task.resume()
        } else {
            delegate?.didMakeRequestFailed("Invalid url!")
        }
    }
}
