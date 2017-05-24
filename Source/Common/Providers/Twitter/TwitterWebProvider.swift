//
//  TwitterProvider.swift
//  Authorizer
//
//  Created by Radislav Crechet on 5/4/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation

public class TwitterWebProvider: TwitterProvider {
    
    public override func authorize(_ completion: @escaping Providing.Completion) {
        requestToken { [unowned self] requestToken, error in
            guard let requestToken = requestToken as? String else {
                completion(nil, error)
                return
            }
            
            self.authenticate(withRequestToken: requestToken) { [unowned self] verifierToken, error in
                guard let verifierToken = verifierToken as? String else {
                    completion(nil, error)
                    return
                }
                
                self.accessToken(withRequestToken: requestToken,
                                 verifierToken: verifierToken) { [unowned self] accessToken, error in
                                    
                                    guard let accessToken = accessToken as? [String: String] else {
                                        completion(nil, error)
                                        return
                                    }
                                    
                                    self.account(withAccessToken: accessToken, completion: completion)
                }
            }
        }
    }
    
    private func requestToken(_ completion: @escaping URLRequest.Completion) {
        let url = URL(string: "https://api.twitter.com/oauth/request_token")!
        let parameters = ["oauth_callback": redirectUri]
        let request = URLRequest(url: url, httpMethod: .POST, parameters: parameters, consumer: consumer)
        
        URLSession.resumeDataTask(with: request) { data, error in
            guard let data = data,
                let parameters = String(data: data, encoding: .utf8),
                let token = parameters.dictionary["oauth_token"] else {
                    
                    if error == nil {
                        LogService.output(AuthorizeError.parseMessage)
                    }
                    
                    completion(nil, error ?? AuthorizeError.parse)
                    return
            }
            
            completion(token, nil)
        }
    }
    
    private func authenticate(withRequestToken requestToken: String, _ completion: @escaping URLRequest.Completion) {
        let parameters = ["oauth_token": requestToken, "force_login": "true"]
        let url = "https://api.twitter.com/oauth/authenticate?\(parameters.string)"
        let request = URLRequest(url: URL(string: url)!)
        
        WebRequestService.load(request, ofProvider: self) { url, error in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            if let parameters = url!.absoluteString.components(separatedBy: "?").last,
                parameters.dictionary["denied"] != nil {
                
                completion(nil, AuthorizeError.cancel)
            } else if let parameters = url!.absoluteString.components(separatedBy: "?").last,
                let token = parameters.dictionary["oauth_verifier"] {
                
                completion(token, nil)
            } else {
                LogService.output(AuthorizeError.parseMessage)
                completion(nil, AuthorizeError.parse)
            }
        }
    }
    
    private func accessToken(withRequestToken requestToken: String,
                             verifierToken: String,
                             _ completion: @escaping URLRequest.Completion) {
        
        let url = URL(string: "https://api.twitter.com/oauth/access_token")!
        let parameters = ["oauth_verifier": verifierToken]
        let access: URLRequest.Access = (token: requestToken, secret: nil)
        
        let request = URLRequest(url: url,
                                 httpMethod: .POST,
                                 parameters: parameters,
                                 consumer: consumer,
                                 access: access)
        
        URLSession.resumeDataTask(with: request) { data, error in
            guard let data = data,
                let parameters = String(data: data, encoding: .utf8),
                let token = parameters.dictionary["oauth_token"],
                let secret = parameters.dictionary["oauth_token_secret"] else {
                    
                    if error == nil {
                        LogService.output(AuthorizeError.parseMessage)
                    }
                    
                    completion(nil, error ?? AuthorizeError.parse)
                    return
            }
            
            completion(["oauth_token": token, "oauth_token_secret": secret], nil)
        }
    }
    
    private func account(withAccessToken accessToken: [String: String], completion: @escaping Providing.Completion) {
        let url = URL(string: "https://api.twitter.com/1.1/account/verify_credentials.json")!
        let access: URLRequest.Access = (token: accessToken["oauth_token"]!, secret: accessToken["oauth_token_secret"]!)
        let request = URLRequest(url: url, httpMethod: .GET, consumer: consumer, access: access)
        
        URLSession.resumeDataTask(with: request) { data, error in
            guard let data = data,
                let account = try? JSONSerialization.jsonObject(with: data) as! [String: Any] else {
                    
                    if error == nil {
                        LogService.output(AuthorizeError.parseMessage)
                    }
                    
                    completion(nil, error ?? AuthorizeError.parse)
                    return
            }
            
            let user = User(id: "\(account["id"]!)",
                name: account["screen_name"] as! String,
                additions: account)
            
            let session = Session(token: accessToken["oauth_token"]!,
                                  user: user,
                                  additions: accessToken)
            
            completion(session, nil)
        }
    }
    
}
