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
    
    public func from(_ nameOfProvider: String) {
        guard let provider = ProviderService.provider(ofType: .base, withName: nameOfProvider) else {
            DebugService.output("There is no provider with name \(nameOfProvider)")
            return
        }
        
        provider.init()!.logout()
    }

}
