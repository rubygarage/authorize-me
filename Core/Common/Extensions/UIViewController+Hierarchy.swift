//
//  UIViewController+Additions.swift
//  Authorizer
//
//  Created by Radislav Crechet on 5/5/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import UIKit

extension UIViewController {
    
    static var top: UIViewController {
        var viewController = UIApplication.shared.keyWindow!.rootViewController!
        
        while let presentedViewController = viewController.presentedViewController {
            viewController = presentedViewController
        }
        
        return viewController
    }
    
}
