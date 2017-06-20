//
//  Logout.swift
//  AuthorizeMe
//
//  Created by Radislav Crechet on 6/20/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation

public class Logout {
    
    public static let me = Logout()
    
    private var provider: Provider!
    
    public func from(_ nameOfProvider: String) {
        let bundleName = Bundle(for: type(of: self)).infoDictionary!["CFBundleName"] as! String
        
        guard let provider = NSClassFromString("\(bundleName).\(nameOfProvider)Provider") as? Provider.Type else {
            DebugService.output("There is no provider with name \(nameOfProvider)")
            return
        }
        
        self.provider = provider.init()
        self.provider.logout()
    }

}
