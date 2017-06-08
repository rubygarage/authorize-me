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
        switch nameOfProvider {
        case _ where nameOfProvider == "Facebook":
            if FacebookProvider() != nil {
                systemProvider = FacebookSystemProvider()
                webProvider = FacebookWebProvider()
            }
        case _ where nameOfProvider == "Twitter":
            if TwitterProvider() != nil {
                systemProvider = TwitterSystemProvider()
                webProvider = TwitterWebProvider()
            }
        case _ where nameOfProvider == "Google":
            webProvider = GoogleWebProvider()
        case _ where nameOfProvider == "Instagram":
            webProvider = InstagramWebProvider()
        case _ where nameOfProvider == "LinkedIn":
            webProvider = LinkedInWebProvider()
        default:
            DebugService.output("There is no provider with name \(nameOfProvider)")
        }
        
        guard systemProvider != nil || webProvider != nil else {
            completion(nil, AuthorizeError.provider)
            return
        }
        
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
