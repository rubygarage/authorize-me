//
//  File.swift
//  Authorizer
//
//  Created by Radislav Crechet on 5/11/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation

public extension URLRequest {
    
    public typealias Consumer = (key: String, secret: String)
    public typealias Access = (token: String?, secret: String?)
    public typealias Completion = (_ token: Any?, _ error: AuthorizeError?) -> Void
    
    public enum HTTPMethod: String {
        case GET, POST
    }
    
    private var nonce: String {
        return UUID().uuidString
    }
    
    private var timestamp: String {
        return String(Int(Date().timeIntervalSince1970))
    }
    
    public init(url: URL,
                httpMethod: HTTPMethod,
                parameters: [String: String]? = nil,
                consumer: Consumer,
                access: Access? = nil) {
        
        self.init(url: url)
        
        self.httpMethod = httpMethod.rawValue
        self.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        
        if let parameters = parameters {
            if httpMethod == .GET {
                let urlParameters = parameters.map { "\($0.encoded)=\($1.encoded)" }.joined(separator: "&")
                self.url = URL(string: "\(url.absoluteString)?\(urlParameters)")
            } else {
                let data = parameters.map { "\($0.encoded)=\($1.encoded)" }.joined(separator: "&").data(using: .utf8)!
                self.httpBody = data
                self.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                self.setValue(String(data.count), forHTTPHeaderField: "Content-Length")
            }
        }
        
        self.setAuthorization(withParameters: parameters, consumer: consumer, access: access)
    }
    
    private mutating func setAuthorization(withParameters parameters: [String: String]? = nil,
                                   consumer: Consumer,
                                   access: Access? = nil) {
        
        var oAuth = ["oauth_consumer_key": consumer.key,
                     "oauth_nonce": nonce,
                     "oauth_signature_method": "HMAC-SHA1",
                     "oauth_timestamp": timestamp,
                     "oauth_version": "1.0"]
        
        if let accessToken = access?.token {
            oAuth["oauth_token"] = accessToken
        }
        
        var baseParameters = oAuth
        
        if let parameters = parameters {
            parameters.forEach { baseParameters[$0] = $1 }
        }
        
        let keys = baseParameters.keys.sorted()
        let baseParametersString = keys.map { "\($0.encoded)=\(baseParameters[$0]!.encoded)" }.joined(separator: "&")
        let baseComponents = [self.httpMethod!, self.url!.absoluteString.encoded, baseParametersString.encoded]
        let signatureBase = baseComponents.joined(separator: "&")
        let signatureKey = "\(consumer.secret.encoded)&\(access?.secret != nil ? access!.secret!.encoded : "")"
        
        oAuth["oauth_signature"] = signatureBase.hash(withKey: signatureKey)
        
        let encodedOAuth = oAuth.map { "\($0.encoded)=\"\($1.encoded)\"" }.joined(separator: ",")
        
        self.setValue("OAuth \(encodedOAuth)", forHTTPHeaderField: "Authorization")
    }
    
}
