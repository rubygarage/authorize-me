//
//  AuthorizerError.swift
//  Authorizer
//
//  Created by Radislav Crechet on 5/12/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation

public enum AuthorizeError: Error {
    
    case provider
    case network
    case parse
    case accounts
    case cancel
    
    static var networkMessage: String {
        return "There is bad network response"
    }
    
    static var parseMessage: String {
        return ""
    }
    
    public static func turnLogOn() {
        LogService.isLogOn = true
    }
    
}
