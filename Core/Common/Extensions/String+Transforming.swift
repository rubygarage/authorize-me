//
//  String+Transforming.swift
//  Authorizer
//
//  Created by Radislav Crechet on 5/12/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation

public extension String {
    
    var dictionary: [String: String] {
        var parameters = [String: String]()
        
        self.components(separatedBy: "&").forEach { tuple in
            let components = tuple.components(separatedBy: "=")
            if let key = components.first, let value = components.last {
                parameters[key] = value
            }
        }
        
        return parameters
    }

}
