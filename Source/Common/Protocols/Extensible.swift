//
//  Extensible.swift
//  Authorizer
//
//  Created by Radislav Crechet on 5/4/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation

public protocol Extensible {
    
    var additions: [String: Any] { get }
    
}
