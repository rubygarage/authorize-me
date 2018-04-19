//
//  AuthorizeMe.swift
//  Authorizer
//
//  Created by Radislav Crechet on 5/17/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation

public class Authorize {
    
    public static let me = Authorize()
    
    private var systemProvider: Provider?
    private var webProvider: Provider?
    
    public func on(_ nameOfProvider: String, _ completion: @escaping Providing.Completion) {
        guard ProviderService.provider(ofType: .base, withName: nameOfProvider) != nil else {
            DebugService.output("There is no provider with name \(nameOfProvider)")
            completion(nil, AuthorizeError.provider)
            return
        }
        
        systemProvider = ProviderService.provider(ofType: .system, withName: nameOfProvider)?.init()
        webProvider = ProviderService.provider(ofType: .web, withName: nameOfProvider)?.init()
        
        authorize { [unowned self] session, error in
            self.systemProvider = nil
            self.webProvider = nil
            
            completion(session, error)
        }
    }
    
    private func authorize(_ completion: @escaping Providing.Completion) {
        if systemProvider != nil {
            authorizeBySystem(withCompletion: completion)
        } else if webProvider != nil {
            authorizeByWeb(withCompletion: completion)
        } else {
            completion(nil, AuthorizeError.provider)
        }
    }
    
    private func authorizeBySystem(withCompletion completion: @escaping Providing.Completion) {
        systemProvider?.authorize { [unowned self] session, error in
            guard let systemError = error,
                systemError == .accounts else {
                    
                    completion(session, error)
                    return
            }
            
            self.authorizeByWeb(withCompletion: completion)
        }
    }
    
    private func authorizeByWeb(withCompletion completion: @escaping Providing.Completion) {
        webProvider?.authorize(completion)
    }
    
}
