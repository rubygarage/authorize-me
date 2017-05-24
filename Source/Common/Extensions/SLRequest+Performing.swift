//
//  SLRequest+Performing.swift
//  Authorizer
//
//  Created by Radislav Crechet on 5/12/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation
import Social

public extension SLRequest {
    
    public typealias Completion = (_ data: Data?, _ error: AuthorizeError?) -> Void
    
    public func perform(_ completion: @escaping Completion) {
        self.perform { data, response, _ in
            DispatchQueue.main.async {
                guard let response = response,
                    response.statusCode == 200 else {
                        
                        LogService.print(AuthorizeError.networkMessage)
                        completion(nil, AuthorizeError.network)
                        return
                }
                
                completion(data, nil)
            }
        }
    }
    
}
