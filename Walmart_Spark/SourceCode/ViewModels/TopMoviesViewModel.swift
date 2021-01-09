//
//  TopMoviesViewModel.swift
//  Walmart_Spark
//
//  Created by Francis Chan on 1/8/21.
//

import Foundation

protocol TopMoviesViewModelDelegate:class {
    func didMakeRequestSuccess()
    func didMakeRequestFailed(_ errorMsg:String)
}

class TopMoviesViewModel:NSObject,ServicesDelegate {
    public weak var delegate: TopMoviesViewModelDelegate?
    
    private var dataModel:DataModel = DataModel()
    private var services:Services = Services()
    private var selectedRow:DataModel.Result = DataModel.Result()
    private var genreDataModel:GenreDataModel = GenreDataModel()

    private var loading = false
    private var currentPage:Int = 1
    private var page:Int = 1
    private var total_pages:Int = 1
    private var total_results:Int = 0

    private var MAX_PAGES:Int = 10

    //Store downloaded image data
    private var images: Dictionary<String,Any> = [:]

    //Services Delegate Method(s)
    func didMakeRequestSuccess(_ dataModel:DataModel) {
         if currentPage == 1 {
            self.dataModel = dataModel
         } else {
            self.dataModel.results.append(contentsOf: dataModel.results)
         }

         currentPage = currentPage + 1
         loading = false
        
         self.page = self.dataModel.page
         self.total_pages = self.dataModel.total_pages
         self.total_results = self.dataModel.total_results

         delegate?.didMakeRequestSuccess()
    }
    
    func didGetGenreSuccess(_ genreDataModel:GenreDataModel){
        self.genreDataModel = genreDataModel
        services.getTopMovies(currentPage)
    }

    func didMakeRequestFailed(_ errorMsg:String){
         currentPage = currentPage + 1
         loading = false
         delegate?.didMakeRequestFailed(errorMsg)
    }
        
    var isLoading:Bool {
        return self.loading
    }
    
    var maxPages:Int {
        return MAX_PAGES
    }

    var getCurrentPage:Int {
        return currentPage
    }

    //getTopMovies
    func getTopMovies(){
        services.delegate = self
        if (!loading) {
            loading = true
            if genreDataModel.genres.count == 0 {
               services.getGenres()
            } else {
               services.getTopMovies(currentPage)
           }
       }
    }
    
    var numberOfSections:Int {
        return 1
    }
    
    var numberOfRowsInSection:Int {
        return dataModel.results.count
    }
    
    //removeAll
    func removeAll() {
        images.removeAll()
        genreDataModel.genres.removeAll()
    }
    
    //poster_path
    func poster_path(_ i:Int,
                     completion: @escaping(_ data:Data) -> Void) {
        //Make sure we have results[].
        if dataModel.results.count == 0 {
           completion(Data())
           return
        }
        
        let result = dataModel.results[i]

        //Make sure we have a url to poster.
        if result.poster_path == "" {
            completion(Data())
            return
        }
        
        //Check images dictionary before downloading again.
        if self.images[result.poster_path] != nil {
                let data:Data? = self.images[result.poster_path] as? Data ?? Data()
                completion(data ?? Data())
            return
        }
        
        let url:String = Configurations.photoUrl  + result.poster_path
        let obj:Services = Services()
        weak var weakSelf = self
        obj.getImage(url) { (data) in
            completion(data)
            DispatchQueue.main.async {
                weakSelf?.images[result.poster_path] = data
            }
        }
    }
    
    //title
    func title(_ i:Int) -> String {
         return dataModel.results[i].title
    }

    //genre
    func genre(_ i:Int) -> String {
        let genre_ids:[Int] = dataModel.results[i].genre_ids
        return getGenres(genre_ids)
    }

    //genre
    func getGenres(_ genre_ids:[Int]) -> String {
        var str:String = ""
        for i in genre_ids {
            let ary = self.genreDataModel.genres.filter{$0.id == i}
            if ary.count == 1 {
                str = str + ary[0].name + " "
            }
        }
        
        return str
    }
    
    //popularity
    func popularity(_ i:Int) -> String {
         return String(dataModel.results[i].popularity)
    }

    //release_date
    func release_date(_ i:Int) -> String {
        let ary = dataModel.results[i].release_date.split(separator: "-")
        if ary.count > 0 {
            return String(ary[0])
        } else {
            return dataModel.results[i].release_date
        }
    }

    //selectedRow
    func setSelectedRow(_ i:Int) {
        let poster_path = dataModel.results[i].poster_path
        
        //poster_path_imageData
        if let data = self.images[poster_path] {
            dataModel.results[i].poster_path_imageData = data as? Data ?? Data()
        }
        
        //genre_names
        dataModel.results[i].genre_names = genre(i)
        
        self.selectedRow = dataModel.results[i]
    }
    
    var getSelectedRow:DataModel.Result {
        return self.selectedRow
    }
}
