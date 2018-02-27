//
//  ViewController.swift
//  AuthorizeMeDemo
//
//  Created by Radislav Crechet on 5/4/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import UIKit
import AuthorizeMe

class AuthorizeViewController: UIViewController {
    
    @IBOutlet var nameOfProviderTextField: UITextField!
    @IBOutlet var authorizeMeButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    @IBAction func authorizeMeButtonPressed(_ sender: Any) {
        guard let text = nameOfProviderTextField.text,
            text.count > 0 else {
                
                return
        }
        
        nameOfProviderTextField.resignFirstResponder()
        nameOfProviderTextField.isEnabled = false
        authorizeMeButton.isHidden = true
        activityIndicator.startAnimating()
        
        Authorize.me.on(text) { [unowned self] session, error in
            self.nameOfProviderTextField.isEnabled = true
            self.authorizeMeButton.isHidden = false
            self.activityIndicator.stopAnimating()
            
            var title = text
            var message: String?
            
            if let session = session {
                message = "\(session.user.name)"
            } else if let error = error,
                error != .cancel {
                
                title = "Error"
                message = "Problem with \(error)"
            }
            
            if let message = message {
                let alertController = AlertService.alert(withTitle: title, message: message)
                self.present(alertController, animated: true)
            }
        }
    }
    
}
