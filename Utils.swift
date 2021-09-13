//
//  Utils.swift
//  Junk
//
//  Created by Francis Chan on 9/12/21.
//
import Foundation

/*
 public struct Text: Decodable {
     var text:String

     enum CodingKeys: String, CodingKey {
         case text
     }

     public init() {
         text = ""
     }

     public init(from decoder:Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
         text = try (container.decodeIfPresent(String.self, forKey: .text) ?? "")
     }
 }
 */

class Utils {
    //convertToDict
    static func convertToDict(_ data:Data) -> [String:Any] {
        var dict:[String:Any] = [:]
        do {
            dict = try JSONSerialization.jsonObject(with:data) as? [String:Any] ?? [:]
        } catch {
            #if DEBUG
            print("Error in 'convertToDict()'.")
            #endif
        }
        return dict
    }

    //convertToJsonString
    static func convertToJsonString(_ data:Data) -> String {
        let jsonString:String = String(decoding: data, as: UTF8.self)

        return jsonString
    }

    //readFile
    static func readFile(_ fileName:String) -> Data? {
        var data:Data?
        
        do {
            if let file = Bundle.main.url(forResource: fileName,
                                          withExtension: "json") {
                
                data = try Data(contentsOf: file)
                return data!
                
            } else {
                return data
            }
        } catch {
            return data
        }//do
    }
}
