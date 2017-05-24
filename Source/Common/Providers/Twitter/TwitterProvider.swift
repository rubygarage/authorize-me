//
//  TwitterProvider.swift
//  Authorizer
//
//  Created by Radislav Crechet on 5/5/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation

public class TwitterProvider: Provider {

    public override var name: String {
        return "Twitter"
    }
    
    var consumer: URLRequest.Consumer {
        return (key: options["consumerKey"] as! String, secret: options["consumerSecret"] as! String)
    }
    
    public required init?() {
        super.init()
        
        guard options["consumerKey"] != nil, options["consumerSecret"] != nil else {
            
            if options["consumerKey"] == nil {
                LogService.output("There is no consumer key in \(name).plist file")
            } else {
                LogService.output("There is no consumer secret in \(name).plist file")
            }
            
            return nil
        }
    }
    
}
