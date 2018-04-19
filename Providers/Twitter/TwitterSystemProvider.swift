//
//  TwitterSystemProvider.swift
//  Authorizer
//
//  Created by Radislav Crechet on 5/5/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation
import Accounts
import Social

@available(iOS, deprecated: 11.0)
public class TwitterSystemProvider: TwitterProvider {

    public required init?() {
        super.init()

        if #available(iOS 11.0, *) {
            DebugService.output(AuthorizeError.deprecateMessage)
            return nil
        }
    }
    
    public override func authorize(_ completion: @escaping Providing.Completion) {
        systemAccount { [unowned self] systemAccount, error in
            guard let systemAccount = systemAccount else {
                completion(nil, error)
                return
            }
            
            self.requestToken { [unowned self] requestToken, error in
                guard let requestToken = requestToken as? String else {
                    completion(nil, error)
                    return
                }
                
                self.accessToken(withRequestToken: requestToken,
                                 systemAccount: systemAccount) { [unowned self] accessToken, error in
                                    
                                    guard let accessToken = accessToken as? [String: String] else {
                                        completion(nil, error)
                                        return
                                    }
                                    
                                    self.remoteAccount(withAccessToken: accessToken,
                                                       systemAccount: systemAccount,
                                                       completion: completion)
                }
            }
        }
    }
    
    private func systemAccount(_ completion: @escaping ACAccountStore.Completion) {
        ACAccountStore.account(withTypeIdentifier: ACAccountTypeIdentifierTwitter, completion: completion)
    }
    
    private func requestToken(_ completion: @escaping URLRequest.Completion) {
        let url = URL(string: "https://api.twitter.com/oauth/request_token")!
        let parameters = ["x_auth_mode": "reverse_auth"]
        let request = URLRequest(url: url, httpMethod: .POST, parameters: parameters, consumer: consumer)
        
        URLSession.resumeDataTask(with: request) { data, error in
            guard let data = data,
                let token = String(data: data, encoding: .utf8) else {
                    
                    if error == nil {
                        DebugService.output(AuthorizeError.parseMessage)
                    }
                    
                    completion(nil, error ?? AuthorizeError.parse)
                    return
            }
            
            completion(token, nil)
        }
    }
    
    private func accessToken(withRequestToken requestToken: String,
                             systemAccount: ACAccount,
                             _ completion: @escaping URLRequest.Completion) {
        
        let url = URL(string: "https://api.twitter.com/oauth/access_token")!
        let parameters = ["x_reverse_auth_parameters": requestToken, "x_reverse_auth_target": consumer.key]
        
        let request = SLRequest(forServiceType: SLServiceTypeTwitter,
                                requestMethod: .POST,
                                url: url,
                                parameters: parameters)!
        
        request.account = systemAccount
        
        request.perform { data, error in
            guard let data = data,
                let parameters = String(data: data, encoding: .utf8),
                let token = parameters.dictionary["oauth_token"],
                let secret = parameters.dictionary["oauth_token_secret"] else {
                    
                    if error == nil {
                        DebugService.output(AuthorizeError.parseMessage)
                    }
                    
                    completion(nil, error ?? AuthorizeError.parse)
                    return
            }
            
            completion(["oauth_token": token, "oauth_token_secret": secret], nil)
        }
    }
    
    private func remoteAccount(withAccessToken accessToken: [String: String],
                               systemAccount: ACAccount,
                               completion: @escaping Providing.Completion) {
        
        let url = URL(string: "https://api.twitter.com/1.1/account/verify_credentials.json")!
        let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, url: url, parameters: nil)!
        request.account = systemAccount
        
        request.perform { data, error in
            guard let data = data,
                let account = try? JSONSerialization.jsonObject(with: data) as! [String: Any] else {
                    
                    if error == nil {
                        DebugService.output(AuthorizeError.parseMessage)
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
