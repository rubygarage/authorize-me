//
//  File.swift
//  Authorizer
//
//  Created by Radislav Crechet on 5/11/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation
import Accounts

public extension ACAccountStore {
    
    public typealias Completion = (_ account: ACAccount?, _ error: AuthorizeError?) -> Void
    
    public static func account(withTypeIdentifier typeIdentifier: String,
                               options: [String: Any]? = nil,
                               completion: @escaping Completion) {
        
        let store = ACAccountStore()
        let type = store.accountType(withAccountTypeIdentifier: typeIdentifier)
        
        store.requestAccessToAccounts(with: type, options: options) { granted, _ in
            DispatchQueue.main.async {
                guard granted,
                    let accounts = store.accounts(with: type) as? [ACAccount],
                    accounts.count > 0 else {
                        
                        if !granted {
                            LogService.output("There is no access to account")
                        } else {
                            LogService.output("There is no account")
                        }
                        
                        completion(nil, AuthorizeError.accounts)
                        return
                }
                
                if accounts.count == 1 {
                    completion(accounts.first!, nil)
                } else {
                    AlertService.chooseAccount(from: accounts, completion: completion)
                }
            }
        }
    }
    
}
