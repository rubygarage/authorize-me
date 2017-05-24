//
//  AlertService.swift
//  Authorizer
//
//  Created by Radislav Crechet on 5/11/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import UIKit
import Accounts

struct AlertService {
    
    static let cancelActionTitle = "Cancel"
    
    static func chooseAccount(from accounts: [ACAccount], completion: @escaping ACAccountStore.Completion) {
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let accountActionHandler: (UIAlertAction) -> Void = { action in
            completion(accounts.filter { "@\($0.username!)" == action.title }.first!, nil)
        }
        
        accounts.forEach { account in
            let title = "@\(account.username!)"
            let accountAction = UIAlertAction(title: title, style: .default, handler: accountActionHandler)
            actionSheetController.addAction(accountAction)
        }
        
        let cancelActionHandler: (UIAlertAction) -> Void = { _ in
            completion(nil, AuthorizeError.cancel)
        }
        
        let cancelAction = UIAlertAction(title: cancelActionTitle, style: .cancel, handler: cancelActionHandler)
        actionSheetController.addAction(cancelAction)
        
        let topViewController = UIViewController.top
        topViewController.present(actionSheetController, animated: true)
    }
    
}
