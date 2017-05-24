//
//  ProviderService.swift
//  Authorizer
//
//  Created by Radislav Crechet on 5/12/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import UIKit

public struct WebRequestService {
    
    public typealias Completion = (_ url: URL?, _ error: AuthorizeError?) -> Void
    
    public static func load(_ request: URLRequest, ofProvider provider: Provider, _ completion: @escaping Completion) {
        let providerController = ProviderController()
        providerController.title = provider.name
        providerController.request = request
        providerController.redirectUri = provider.redirectUri
        providerController.completion = completion
        
        let topViewController = UIViewController.top
        topViewController.present(providerController, animated: true)
    }
    
}
