//
//  FacebookProvider.swift
//  Authorizer
//
//  Created by Radislav Crechet on 5/16/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation

public class FacebookProvider: Provider {
    
    public override var name: String {
        return "Facebook"
    }
    
    var appId: String {
        return options["appId"] as! String
    }
    
    public required init?() {
        super.init()
        
        guard options["appId"] != nil else {
            LogService.print("There is no app id in \(name).plist file")
            return nil
        }
    }
    
    func account(withAccessToken accessToken: [String: String], completion: @escaping Providing.Completion) {
        let parameters = ["access_token": accessToken["access_token"]!]
        let url = URL(string: "https://graph.facebook.com/me?\(parameters.string)")!
        let request = URLRequest(url: url)
        
        URLSession.resumeDataTask(with: request) { data, error in
            guard let data = data,
                let account = try? JSONSerialization.jsonObject(with: data) as! [String: Any] else {
                    
                    if error == nil {
                        LogService.print(AuthorizeError.parseMessage)
                    }
                    
                    completion(nil, error ?? AuthorizeError.parse)
                    return
            }
            
            let user = User(id: "\(account["id"]!)",
                name: account["name"] as! String,
                additions: account)
            
            let session = Session(token: accessToken["access_token"]!,
                                  user: user,
                                  additions: accessToken)
            
            completion(session, nil)
        }
    }
    
}
