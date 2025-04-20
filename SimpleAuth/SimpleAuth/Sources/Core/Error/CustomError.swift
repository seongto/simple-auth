//
//  CustomError.swift
//  SimpleAuth
//
//  Created by MaxBook on 4/19/25.
//

import Foundation

enum CustomError: Error {
    enum PasswordManagerError: LocalizedError {
        case encryptionFailed
        
        var errorDescription: String? {
            switch self {
            case .encryptionFailed:
                return "비밀번호 암호화 실패"
            }
        }
    }
    
    enum CoreDataStackError: LocalizedError {
        case dataTransformationFailed
        case noMatchingItem
        
        var errorDescription: String? {
            switch self {
            case .dataTransformationFailed:
                return "엔티티 -> 모델 변환 실패"
            case .noMatchingItem:
                return "일치하는 아이템 없음"
            }
        }
    }
}
