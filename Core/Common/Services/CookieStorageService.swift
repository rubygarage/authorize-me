//
//  CookieStorageService.swift
//  AuthorizeMeDemo
//
//  Created by Radislav Crechet on 6/1/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation

struct CookieStorageService {
    
    static func deleteCookies(withDomainLike substring: String) {
        guard let cookies = HTTPCookieStorage.shared.cookies else {
            return
        }
        
        cookies.forEach { cookie in
            if cookie.domain.range(of: substring) != nil {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
    }
    
}
