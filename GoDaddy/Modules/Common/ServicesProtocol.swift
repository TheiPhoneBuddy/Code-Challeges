//
//  ServicesProtocol.swift
//  NameSearchTests
//
//  Created by Francis Chan on 5/17/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import Foundation

protocol ServicesProtocol:class {
    func makeRequest(_ request:Services.Request,
                     callback:@escaping Services.callback)
}
