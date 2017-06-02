//
//  InstagramWebProvider.swift
//  AuthorizeMeDemo
//
//  Created by Radislav Crechet on 6/1/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation

public class InstagramWebProvider: InstagramProvider {
    
    public override func authorize(_ completion: @escaping Providing.Completion) {
        CookieStorageService.deleteCookies(withDomainLike: "instagram")
        
        accessToken { [unowned self] accessToken, error in
            guard let accessToken = accessToken as? String else {
                completion(nil, error)
                return
            }
            
            self.account(withAccessToken: accessToken, completion: completion)
        }
    }
    
    private func accessToken(_ completion: @escaping URLRequest.Completion) {
        let parameters = ["client_id": clientId,
                          "redirect_uri": redirectUri,
                          "response_type": "token"]
        
        let url = "https://instagram.com/oauth/authorize/?\(parameters.string)"
        let request = URLRequest(url: URL(string: url)!)
        
        WebRequestService.load(request, ofProvider: self) { url, error in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            if let parameters = url!.absoluteString.components(separatedBy: "#").last,
                let token = parameters.dictionary["access_token"] {
                
                completion(token, nil)
            } else {
                DebugService.output(AuthorizeError.parseMessage)
                completion(nil, AuthorizeError.parse)
            }
        }
    }
    
    private func account(withAccessToken accessToken: String, completion: @escaping Providing.Completion) {
        let parameters = ["access_token": accessToken]
        let url = URL(string: "https://api.instagram.com/v1/users/self?\(parameters.string)")!
        let request = URLRequest(url: url)
        
        URLSession.resumeDataTask(with: request) { data, error in
            guard let data = data,
                let parameters = try? JSONSerialization.jsonObject(with: data) as! [String: Any],
                let account = parameters["data"] as? [String: Any] else {
                    
                    if error == nil {
                        DebugService.output(AuthorizeError.parseMessage)
                    }
                    
                    completion(nil, error ?? AuthorizeError.parse)
                    return
            }
            
            let user = User(id: "\(account["id"]!)",
                name: account["username"] as! String,
                additions: account)
            
            let session = Session(token: accessToken,
                                  user: user,
                                  additions: ["access_token": accessToken])
            
            completion(session, nil)
        }
    }
    
}
