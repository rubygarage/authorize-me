//
//  FacebookWebProvider.swift
//  Authorizer
//
//  Created by Radislav Crechet on 5/16/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation

public class FacebookWebProvider: FacebookProvider {
    
    public override func authorize(_ completion: @escaping Providing.Completion) {
        CookieStorageService.deleteCookies(withDomainLike: "facebook")
        
        accessToken { [unowned self] accessToken, error in
            guard let accessToken = accessToken as? [String: String] else {
                completion(nil, error)
                return
            }
            
            self.account(withAccessToken: accessToken, completion: completion)
        }
    }

    private func accessToken(_ completion: @escaping URLRequest.Completion) {
        let parameters = ["client_id": appId, "redirect_uri": redirectUri, "response_type": "token", "scope": "email"]
        let url = "https://www.facebook.com/dialog/oauth?\(parameters.string)"
        let request = URLRequest(url: URL(string: url)!)
        
        WebRequestService.load(request, ofProvider: self) { url, error in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            if let parameters = url!.absoluteString.components(separatedBy: "?").last,
                parameters.dictionary["error"] != nil {
                
                completion(nil, AuthorizeError.cancel)
            } else if let parameters = url!.absoluteString.components(separatedBy: "#").last,
                parameters.dictionary["access_token"] != nil,
                parameters.dictionary["expires_in"] != nil {
                
                completion(parameters.dictionary, nil)
            } else {
                DebugService.output(AuthorizeError.parseMessage)
                completion(nil, AuthorizeError.parse)
            }
        }
    }

}
