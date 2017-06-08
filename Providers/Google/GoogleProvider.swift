//
//  GoogleProvider.swift
//  AuthorizeMe
//
//  Created by Radislav Crechet on 6/1/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation

public class GoogleProvider: Provider {
    
    typealias Client = (id: String, secret: String)
    
    public override var name: String {
        return "Google"
    }
    
    var client: Client {
        return (id: options["clientId"] as! String, secret: options["clientSecret"] as! String)
    }
    
    public required init?() {
        super.init()
        
        guard options["clientId"] != nil, options["clientSecret"] != nil else {
            
            if options["clientId"] == nil {
                DebugService.output("There is no client id in \(name).plist file")
            } else {
                DebugService.output("There is no client secret in \(name).plist file")
            }
            
            return nil
        }
    }
    
}
