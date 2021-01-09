//
//  Utils.swift
//  Walmart_Spark
//
//  Created by Francis Chan on 1/8/21.

import Foundation
import UIKit

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
    
    //displayAlert
    static public func displayAlert(_ title:String, message:String, vc:UIViewController){
        let alert:UIAlertController = UIAlertController(title: title,
                                                        message: message,
                                                        preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: UIAlertAction.Style.default,
                                      handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
}
