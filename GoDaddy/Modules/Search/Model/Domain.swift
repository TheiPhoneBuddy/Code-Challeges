//
//  Domain.swift
//  NameSearchTests
//
//  Created by Francis Chan on 5/18/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

public struct Domain {
    let name: String
    let price: String
    let productId: Int
    
    init(name:String,price:String,productId:Int) {
        self.name = name
        self.price = price
        self.productId = productId
    }
}
