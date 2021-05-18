//
//  Utils.swift
//  NameSearch
//
//  Created by Francis Chan on 5/17/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import Foundation

public enum ErrorHandler: Error {
    case errorMsg(String)
}

class Utils {
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
