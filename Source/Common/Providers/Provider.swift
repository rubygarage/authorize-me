//
//  Provider.swift
//  Authorizer
//
//  Created by Radislav Crechet on 5/4/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation

public class Provider: Providing {
    
    public var name: String {
        return "Provider"
    }
    
    public var redirectUri: String {
        return options["redirectUri"] as! String
    }
    
    public var options = [String: Any]()
    
    public required init?() {
        guard let path = Bundle.main.path(forResource: name, ofType: "plist"),
            let contents = NSDictionary(contentsOfFile: path) as? [String: Any] else {
                
                LogService.print("There is no \(name).plist file")
                return nil
        }
        
        if contents["redirectUri"] == nil {
            LogService.print("There is no redirect uri in \(name).plist file")
            return nil
        }
        
        options = contents
    }
    
    public func authorize(_ completion: @escaping Providing.Completion) {
        LogService.print("There is no implementation of authorization function")
        completion(nil, AuthorizeError.provider)
    }
    
}
