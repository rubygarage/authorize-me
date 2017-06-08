//
//  FacebookSystemProvider.swift
//  Authorizer
//
//  Created by Radislav Crechet on 5/17/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation
import Accounts
import Social

public class FacebookSystemProvider: FacebookProvider {
    
    public required init?() {
        super.init()
        
        if #available(iOS 11.0, *) {
            DebugService.output(AuthorizeError.deprecateMessage)
            return nil
        }
    }
    
    public override func authorize(_ completion: @escaping Providing.Completion) {
        systemAccount { [unowned self] systemAccount, error in
            guard let systemAccount = systemAccount,
                let token = systemAccount.credential.oauthToken else {
                    
                completion(nil, error)
                return
            }
            
            let accessToken = ["access_token": token]
            self.account(withAccessToken: accessToken, completion: completion)
        }
    }
    
    private func systemAccount(_ completion: @escaping ACAccountStore.Completion) {
        let options: [String: Any] = [ACFacebookAppIdKey: appId,
                                      ACFacebookPermissionsKey: ["email"],
                                      ACFacebookAudienceKey: [ACFacebookAudienceOnlyMe]]
        
        ACAccountStore.account(withTypeIdentifier: ACAccountTypeIdentifierFacebook,
                               options: options,
                               completion: completion)
    }

}
