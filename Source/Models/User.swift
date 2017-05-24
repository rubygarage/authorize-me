//
//  User.swift
//  Authorizer
//
//  Created by Radislav Crechet on 5/4/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation

public struct User: Extensible {
    
    public var id: String
    public var name: String
    public var additions = [String: Any]()
    
}
