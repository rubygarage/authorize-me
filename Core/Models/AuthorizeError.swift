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
    
    public static var networkMessage: String {
        return "There is bad network response"
    }
    
    public static var parseMessage: String {
        return "There is wrong parse of network response"
    }
    
    public static var deprecateMessage: String {
        return "The identifiers for system account types were deprecated"
    }
    
}
