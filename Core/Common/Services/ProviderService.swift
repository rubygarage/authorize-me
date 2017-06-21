//
//  ProviderService.swift
//  AuthorizeMe
//
//  Created by Radislav Crechet on 6/21/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation

class ProviderService {
    
    enum ProviderType {
        case base, system, web
    }
    
    static var bundleName: String {
        return Bundle(for: type(of: self) as! AnyClass).infoDictionary!["CFBundleName"] as! String
    }
    
    static func provider(ofType type: ProviderType, withName nameOfProvider: String) -> Provider.Type? {
        let providerType = type == .base ? "Provider" : type == .system ? "SystemProvider" : "WebProvider"
        
        if let provider = NSClassFromString("\(bundleName).\(nameOfProvider)\(providerType)") as? Provider.Type {
            return provider
        }
        
        return nil
    }
    
}
