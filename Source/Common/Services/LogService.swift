//
//  LogService.swift
//  AuthorizeMe
//
//  Created by Radislav Crechet on 5/23/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation

struct LogService {
    
    static var isLogOn = false
    
    static func output(_ message: String) {
        #if DEBUG
            if isLogOn {
                print("AuthorizeMe: \(message)")
            }
        #endif
    }
    
}
