//
//  Dictionary+Transforming.swift
//  Authorizer
//
//  Created by Radislav Crechet on 5/15/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation

public extension Dictionary {
    
    public var string: String {
        return self.map { "\($0)=\($1)" }.joined(separator: "&")
    }

}
