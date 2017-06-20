//
//  Provider.swift
//  Authorizer
//
//  Created by Radislav Crechet on 5/4/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation

open class Provider: Providing {
    
    open var name: String {
        return "Provider"
    }
    
    public var redirectUri: String {
        return options["redirectUri"] as! String
    }
    
    public var options = [String: Any]()
    
    public required init?() {
        guard let path = Bundle.main.path(forResource: name, ofType: "plist"),
            let contents = NSDictionary(contentsOfFile: path) as? [String: Any] else {
                
                DebugService.output("There is no \(name).plist file")
                return nil
        }
        
        if contents["redirectUri"] == nil {
            DebugService.output("There is no redirect uri in \(name).plist file")
            return nil
        }
        
        options = contents
    }
    
    open func authorize(_ completion: @escaping Providing.Completion) {
        DebugService.output("There is no implementation of authorization function")
        completion(nil, AuthorizeError.provider)
    }
    
    public func logout() {
        CookieStorageService.deleteCookies(withDomainLike: name.lowercased())
    }
    
}
