//
//  LogService.swift
//  AuthorizeMe
//
//  Created by Radislav Crechet on 5/23/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation

public struct LogService {
    
    static var isLogOn = false
    
    public static func turnLogOn() {
        LogService.isLogOn = true
    }
    
    static func output(_ message: String) {
        #if DEBUG
            if isLogOn {
                print("AuthorizeMe: \(message)")
            }
        #endif
    }
    
}
