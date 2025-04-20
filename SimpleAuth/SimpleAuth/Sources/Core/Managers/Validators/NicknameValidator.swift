//
//  NickNameValidator.swift
//  SimpleAuth
//
//  Created by MaxBook on 4/20/25.
//

import Foundation

protocol NicknameValidatorProtocol {
    static func validate(_ nickname: String) -> Result<Void, ValidationError>
}

struct NicknameValidator: NicknameValidatorProtocol {
    /// 사용자 닉네임의 유효성을 검사합니다.
    /// - Parameter nickname: 사용자가 입력한 닉네임
    /// - Returns: 각 단계별 유효성 검사에 실패한 경우의 그 원인을 수집하여 반환. 최종적으로 사용자에게 Alert로 띄워주기.
    ///            errors.isEmpty 로 유효성 검사 판단.
    static func validate(_ nickname: String) -> Result<Void, ValidationError> {
        var errors: [String] = []
        
        // 1. 허용된 문자만 사용
        if !NSPredicate(format: "SELF MATCHES %@", "^[A-Za-z0-9_-]+$").evaluate(with: nickname) {
            errors.append("별명은 영문 대소문자, 숫자, 언더바(_), 하이픈(-)만 사용할 수 있습니다.")
        }
        
        // 2. 공백 금지
        if nickname.contains(" ") {
            errors.append("별명은 공백을 포함할 수 없습니다.")
        }
        
        // 3. 길이 제한 3 - 20
        if nickname.count < 3 || nickname.count > 20 {
            errors.append("별명은 3자 이상 20자 이하여야 합니다.")
        }
        
        // 4. 숫자만으로 이루어진 별명 금지
        if NSPredicate(format: "SELF MATCHES %@", "^[0-9]+$").evaluate(with: nickname) {
            errors.append("별명은 숫자만으로 구성될 수 없습니다.")
        }
        
        if errors.isEmpty {
            return .success(())
        } else {
            return .failure(ValidationError(messages: errors))
        }
    }
}
