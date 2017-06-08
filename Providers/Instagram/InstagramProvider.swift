//
//  InstagramProvider.swift
//  AuthorizeMeDemo
//
//  Created by Radislav Crechet on 6/1/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation

public class InstagramProvider: Provider {
    
    public override var name: String {
        return "Instagram"
    }
    
    var clientId: String {
        return options["clientId"] as! String
    }
    
    public required init?() {
        super.init()
        
        guard options["clientId"] != nil else {
            DebugService.output("There is no client id in \(name).plist file")
            return nil
        }
    }
    
}
