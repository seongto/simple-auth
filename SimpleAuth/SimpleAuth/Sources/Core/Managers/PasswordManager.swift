//
//  PasswordManager.swift
//  SimpleAuth
//
//  Created by MaxBook on 4/19/25.
//

import Foundation
import CryptoKit


struct PasswordManager {
    static func encryptPassword(_ password: String) throws -> String {
        guard let data = password.data(using: .utf8) else {
            throw CustomError.PasswordManagerError.encryptionFailed
        }
        
        let result = {
            let digest = SHA256.hash(data: data)
            let hashString = digest
                .compactMap { String(format: "%02x", $0) }
                .joined()
            return hashString
        }
        
        return result()
    }
}
