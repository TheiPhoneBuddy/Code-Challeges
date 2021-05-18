//
//  Utils.swift
//  NameSearch
//
//  Created by Francis Chan on 5/17/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import Foundation

class Utils {
    //decode
    static func decode<T: Codable>(_ data: Data) -> T {
         let decoder = JSONDecoder()

         guard let decodedData = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode data.")
         }

         return decodedData
     }
    
    //getPathToFile
    static func getPathToFile(_ fileName:String,
                       fileExtension:String? = "json") -> String {
        var pathToFile:String = ""
        var withExtension:String = "json"
        
        if let fileExtension =  fileExtension {
           withExtension = fileExtension
        }
        
        let url:URL? = Bundle.main.url(forResource: fileName,
                                       withExtension: withExtension)
        if let url = url {
           pathToFile = url.absoluteString
        }
        
        return pathToFile
    }    
}
