//
//  Credential.swift
//  Authorizer
//
//  Created by Radislav Crechet on 5/4/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation

public struct Session: Extensible {
    
    public var token: String
    public var user: User
    public var additions = [String: Any]()
    
}
