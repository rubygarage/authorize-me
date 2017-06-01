//
//  UserAgentService.swift
//  AuthorizeMeDemo
//
//  Created by Radislav Crechet on 6/1/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation

public struct UserAgentService {
    
    public static func substitute() {
        let userAgent = "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36"
        let defaults: [String: Any] = ["UserAgent": userAgent]
        UserDefaults.standard.register(defaults: defaults)
    }
    
}
