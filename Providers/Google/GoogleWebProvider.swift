//
//  GoogleWebProvider.swift
//  AuthorizeMe
//
//  Created by Radislav Crechet on 6/1/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation

public class GoogleWebProvider: GoogleProvider {
    
    private typealias Completion = (_ code: String?, _ error: AuthorizeError?) -> Void
    
    public override func authorize(_ completion: @escaping Providing.Completion) {
        UserAgentService.substitute()
        
        code { [unowned self] code, error in
            guard let code = code else {
                completion(nil, error)
                return
            }
            
            self.accessToken(withCode: code) { [unowned self] accessToken, error in
                guard let accessToken = accessToken as? [String: Any] else {
                    completion(nil, error)
                    return
                }
                
                self.account(withAccessToken: accessToken, completion: completion)
            }
        }
    }
    
    private func code(_ completion: @escaping Completion) {
        let parameters = ["client_id": client.id,
                          "redirect_uri": redirectUri,
                          "response_type": "code",
                          "scope": "profile email openid".encoded]
        
        let url = "https://accounts.google.com/o/oauth2/v2/auth?\(parameters.string)"
        let request = URLRequest(url: URL(string: url)!)
        
        WebRequestService.load(request, ofProvider: self) { url, error in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            if let parameters = url!.absoluteString.components(separatedBy: "?").last,
                let code = parameters.dictionary["code"] {
                
                completion(code, nil)
            } else {
                DebugService.output(AuthorizeError.parseMessage)
                completion(nil, AuthorizeError.parse)
            }
        }
    }
    
    private func accessToken(withCode code: String, _ completion: @escaping URLRequest.Completion) {
        let parameters = ["code": code,
                          "client_id": client.id,
                          "client_secret": client.secret,
                          "redirect_uri": redirectUri.encoded,
                          "grant_type": "authorization_code"]
        
        let url = URL(string: "https://www.googleapis.com/oauth2/v4/token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = parameters.string.data(using: .utf8)
        
        URLSession.resumeDataTask(with: request) { data, error in
            guard let data = data,
                let parameters = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                parameters["access_token"] != nil,
                parameters["id_token"] != nil,
                parameters["expires_in"] != nil,
                parameters["token_type"] != nil else {
                    
                    if error == nil {
                        DebugService.output(AuthorizeError.parseMessage)
                    }
                    
                    completion(nil, error ?? AuthorizeError.parse)
                    return
            }
            
            completion(parameters, nil)
        }
    }
    
    private func account(withAccessToken accessToken: [String: Any], completion: @escaping Providing.Completion) {
        let parameters = ["access_token": accessToken["access_token"]!]
        let url = URL(string: "https://www.googleapis.com/userinfo/v2/me?\(parameters.string)")!
        let request = URLRequest(url: url)
        
        URLSession.resumeDataTask(with: request) { data, error in
            guard let data = data,
                let account = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    
                    if error == nil {
                        DebugService.output(AuthorizeError.parseMessage)
                    }
                    
                    completion(nil, error ?? AuthorizeError.parse)
                    return
            }
            
            let user = User(id: "\(account["id"]!)",
                name: account["name"] as! String,
                additions: account)
            
            let session = Session(token: accessToken["access_token"]! as! String,
                                  user: user,
                                  additions: accessToken)
            
            completion(session, nil)
        }
    }
    
}
