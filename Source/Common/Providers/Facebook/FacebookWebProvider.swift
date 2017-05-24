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
        deleteAssociatedCookies()
        
        accessToken { [unowned self] accessToken, error in
            guard let accessToken = accessToken as? [String: String] else {
                completion(nil, error)
                return
            }
            
            self.account(withAccessToken: accessToken, completion: completion)
        }
    }
    
    private func deleteAssociatedCookies() {
        guard let cookies = HTTPCookieStorage.shared.cookies else {
            return
        }
        
        cookies.forEach { cookie in
            if cookie.domain == ".facebook.com" {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
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
                let token = parameters.dictionary["access_token"],
                let expire = parameters.dictionary["expires_in"] {
                
                completion(["access_token": token, "expires_in": expire], nil)
            } else {
                LogService.print(AuthorizeError.parseMessage)
                completion(nil, AuthorizeError.parse)
            }
        }
    }

}
