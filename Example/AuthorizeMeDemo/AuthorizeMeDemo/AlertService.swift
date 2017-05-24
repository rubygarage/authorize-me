//
//  AlertService.swift
//  AuthorizeMeDemo
//
//  Created by Radislav Crechet on 5/23/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import UIKit

struct AlertService {
    
    static func alert(withTitle title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
}
