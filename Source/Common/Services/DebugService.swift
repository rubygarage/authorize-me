//
//  LogService.swift
//  AuthorizeMe
//
//  Created by Radislav Crechet on 5/23/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation

public struct DebugService {
    
    public static var isNeedOutput = false
    
    static func output(_ message: String) {
        #if DEBUG
            if isNeedOutput {
                print("AuthorizeMe: \(message)")
            }
        #endif
    }
    
}
