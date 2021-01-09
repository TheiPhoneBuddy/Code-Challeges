//
//  GenreDataModel.swift
//  Walmart_Spark
//
//  Created by Francis Chan on 1/8/21.
//

import Foundation

//GenreDataModel
struct GenreDataModel:Codable {
    //Genre
    struct Genre:Codable {
        var id:Int = 0
        var name:String = ""

        public init() {
            self.id = 0
            self.name = ""
        }
        
        enum CodingKeys: String, CodingKey {
             case id
             case name
        }

        public init(from decoder:Decoder) throws {
           let container = try decoder.container(keyedBy: CodingKeys.self)

           //id
           self.id = try (container.decodeIfPresent(Int.self, forKey: .id) ?? 0)
            
            //name
            self.name = try (container.decodeIfPresent(String.self, forKey: .name) ?? "")
        }
    }

    var genres:[Genre] = []

    public init() {
        self.genres = []
    }

    enum CodingKeys: String, CodingKey {
         case genres
    }
    
    public init(from decoder:Decoder) throws {
       let container = try decoder.container(keyedBy: CodingKeys.self)

        //genres
        self.genres = try (container.decodeIfPresent([Genre].self, forKey: .genres) ?? [Genre]())
    }
}
