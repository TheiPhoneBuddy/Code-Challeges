//
//  DataModel.swift
//  Walmart_Spark
//
//  Created by Francis Chan on 1/8/21.
//

import Foundation
    //DataModel
    struct DataModel: Codable {
        //Result
        struct Result: Codable {
            var id:Int = 0
            var vote_count:Int = 0

            var vote_average:Double = 0.0
            var popularity:Double = 0.0

            var title:String = ""
            var overview:String = ""
            var poster_path:String = ""
            var poster_path_imageData:Data = Data()
            var release_date:String = ""
            var original_language:String = ""
            var genre_ids:[Int] = []
            var genre_names:String = ""

            enum CodingKeys: String, CodingKey {
                case id
                case vote_count

                case vote_average
                case popularity

                case title
                case overview
                case poster_path
                case release_date
                case original_language
                case genre_ids
            }
            
            public init() {
                self.id = 0
                self.vote_count = 0

                self.vote_average = 0.0
                self.popularity = 0.0

                self.title = ""
                self.overview = ""
                self.poster_path = ""
                self.poster_path_imageData = Data()
                self.release_date = ""
                self.original_language = ""
                self.genre_ids = []
                self.genre_names = "" //Not in json dump.
            }
            
            public init(from decoder:Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                //id
                self.id = try (container.decodeIfPresent(Int.self, forKey: .id) ?? 0)
                
                //vote_count
                self.vote_count = try (container.decodeIfPresent(Int.self, forKey: .vote_count) ?? 0)
                
                //vote_average
                self.vote_average = try (container.decodeIfPresent(Double.self, forKey: .vote_average) ?? 0.0)
                
                //popularity
                self.popularity = try (container.decodeIfPresent(Double.self, forKey: .popularity) ?? 0.0)

                //title
                self.title = try (container.decodeIfPresent(String.self, forKey: .title) ?? "")
                
                //overview
                self.overview = try (container.decodeIfPresent(String.self, forKey: .overview) ?? "")
                
                //poster_path
                self.poster_path = try (container.decodeIfPresent(String.self, forKey: .poster_path) ?? "")
                
                //release_date
                self.release_date = try (container.decodeIfPresent(String.self, forKey: .release_date) ?? "")
                
                //original_language
                self.original_language = try (container.decodeIfPresent(String.self, forKey: .original_language) ?? "")
                
                //genre_ids
                self.genre_ids = try (container.decodeIfPresent([Int].self, forKey: .genre_ids) ?? [Int]())
            }
        }
        
        var page:Int = 0
        var total_pages:Int = 0
        var total_results:Int = 0
        var results:[Result] = []
          
        enum CodingKeys: String, CodingKey {
            case page
            case total_pages
            case total_results
            case results
        }

        public init() {
            self.page = 0
            self.total_pages = 0
            self.total_results = 0
            self.results = []
        }

        public init(from decoder:Decoder) throws {
           let container = try decoder.container(keyedBy: CodingKeys.self)

           //page
           self.page = try (container.decodeIfPresent(Int.self, forKey: .page) ?? 0)

           //total_pages
           self.total_pages = try (container.decodeIfPresent(Int.self, forKey: .total_pages) ?? 0)

           //total_results
           self.total_results = try (container.decodeIfPresent(Int.self, forKey: .total_results) ?? 0)

           //results
           self.results = try (container.decodeIfPresent([Result].self, forKey: .results) ?? [Result]())
        }
}
