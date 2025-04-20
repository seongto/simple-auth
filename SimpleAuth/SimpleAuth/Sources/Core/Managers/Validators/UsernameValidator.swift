//
//  ValidateUsernameUseCase.swift
//  SimpleAuth
//
//  Created by MaxBook on 4/19/25.
//
//

import Foundation

protocol UsernameValidatorProtocol {
    static func validate(_ username: String) -> Result<Void, ValidationError>
}

struct UsernameValidator: UsernameValidatorProtocol {
    /// 이메일 아이디의 유효성을 검사합니다.
    /// - Parameter username: 사용자가 입력한 이메일
    /// - Returns: 각 단계별 유효성 검사에 실패한 경우의 그 원인을 수집하여 반환. 최종적으로 사용자에게 Alert로 띄워주기.
    ///            errors.isEmpty 로 유효성 검사 판단.
    static func validate(_ username: String) -> Result<Void, ValidationError> {
        var errors: [String] = []
        
        // 1. 이메일 양식을 준수했는지 체크
        if !NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: username) {
            errors.append("아이디는 적합한 형식의 이메일만 사용할 수 있습니다.")
        }
        
        // 2. 공백 금지
        if username.contains(" ") {
            errors.append("아이디에는 공백을 포함할 수 없습니다.")
        }
        
        // 3. 길이 제한 4 - 50
        if username.count < 4 || username.count > 50 {
            errors.append("아이디는 4자 이상 50자 이하여야 합니다.")
        }
        
        // 4. 숫자만으로 이루어진 아이디 금지
        if NSPredicate(format: "SELF MATCHES %@", "^[0-9]+$").evaluate(with: username) {
            errors.append("아이디는 숫자만으로 구성될 수 없습니다.")
        }
        
        if errors.isEmpty {
            return .success(())
        } else {
            return .failure(ValidationError(messages: errors))
        }
    }
}
