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
    private var webProvider: Provider!
    
    public func on(_ nameOfProvider: String, _ completion: @escaping Providing.Completion) {
        let bundleName = Bundle(for: type(of: self)).infoDictionary!["CFBundleName"] as! String
        
        guard (NSClassFromString("\(bundleName).\(nameOfProvider)Provider") as? Provider.Type) != nil else {
            DebugService.output("There is no provider with name \(nameOfProvider)")
            completion(nil, AuthorizeError.provider)
            return
        }
        
        if let provider = NSClassFromString("\(bundleName).\(nameOfProvider)SystemProvider") as? Provider.Type {
            systemProvider = provider.init()
        }
        
        webProvider = (NSClassFromString("\(bundleName).\(nameOfProvider)WebProvider") as! Provider.Type).init()
        
        authorize { [unowned self] session, error in
            self.systemProvider = nil
            self.webProvider = nil
            
            completion(session, error)
        }
    }
    
    private func authorize(_ completion: @escaping Providing.Completion) {
        if systemProvider != nil {
            authorizeBySystem(withCompletion: completion)
        } else {
            authorizeByWeb(withCompletion: completion)
        }
    }
    
    private func authorizeBySystem(withCompletion completion: @escaping Providing.Completion) {
        systemProvider!.authorize { [unowned self] session, error in
            guard let systemError = error,
                systemError == .accounts else {
                    
                    completion(session, error)
                    return
            }
            
            self.authorizeByWeb(withCompletion: completion)
        }
    }
    
    private func authorizeByWeb(withCompletion completion: @escaping Providing.Completion) {
        webProvider.authorize(completion)
    }
    
}
