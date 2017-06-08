//
//  String+Hashing.swift
//  Authorizer
//
//  Created by Radislav Crechet on 5/8/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation
import CommonCrypto

extension String {
    
    func hash(withKey key: String) -> String {
        let lengthOfData = self.lengthOfBytes(using: .utf8)
        let lengthOfKey = key.lengthOfBytes(using: .utf8)
        
        let data = self.cString(using: .utf8)!
        let key = key.cString(using: .utf8)!
        
        var bytes = [CUnsignedChar](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1), key, lengthOfKey, data, lengthOfData, &bytes)
        
        return Data(bytes: bytes).base64EncodedString()
    }
    
}
