//
//  MovieDataModel.swift
//  Walmart_Spark
//
//  Created by Francis Chan on 1/10/21.
//

import Foundation

//MovieDataModel
struct MovieDataModel:Codable {
    var homepage:String = ""
    
    public init() {
        self.homepage = ""
    }

    enum CodingKeys: String, CodingKey {
         case homepage
    }
    
    public init(from decoder:Decoder) throws {
       let container = try decoder.container(keyedBy: CodingKeys.self)

        //homepage
        self.homepage = try (container.decodeIfPresent(String.self, forKey: .homepage) ?? "")
    }
}
