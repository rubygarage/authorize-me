//
//  URLSession+Resuming.swift
//  Authorizer
//
//  Created by Radislav Crechet on 5/12/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation

public extension URLSession {
    
    public typealias Completion = (_ data: Data?, _ error: AuthorizeError?) -> Void
    
    public static func resumeDataTask(with request: URLRequest, _ completion: @escaping Completion) {
        let task = URLSession.shared.dataTask(with: request) { data, response, _ in
            DispatchQueue.main.async {
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200 else {
                        
                        DebugService.output(AuthorizeError.networkMessage)
                        completion(nil, AuthorizeError.network)
                        return
                }
                
                completion(data, nil)
            }
        }
        
        task.resume()
    }
    
}
