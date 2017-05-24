//
//  Provider.swift
//  Authorizer
//
//  Created by Radislav Crechet on 5/4/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation

public protocol Providing {
    
    typealias Completion = (_ session: Session?, _ error: AuthorizeError?) -> Void
    
    var name: String { get }
    var options: [String: Any] { get }
    
    init?()
    
    func authorize(_ completion: @escaping Completion)
    
}
