//
//  String+Encoding.swift
//  Authorizer
//
//  Created by Radislav Crechet on 5/11/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation

extension String {
    
    var encoded: String {
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacters)!
    }
    
    private var allowedCharacters: CharacterSet {
        return CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[]").inverted
    }
    
}
