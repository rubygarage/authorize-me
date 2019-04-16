//
//  AppDelegate.swift
//  AuthorizeMeDemo
//
//  Created by Radislav Crechet on 5/22/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import UIKit
import AuthorizeMe

@UIApplicationMain

class AppDelegate: UIResponder {

    var window: UIWindow?
    
}

extension AppDelegate: UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        DebugService.isNeedOutput = true

        return true
    }
}
