//
//  SignupUseCase.swift
//  SimpleAuth
//
//  Created by MaxBook on 4/19/25.
//

import Foundation


/// 새로운 사용자 등록 UseCase
///
/// - execute(_:) : 사용자 등록을 실행하는 메서드
struct SignupUseCase: UseCaseProtocol {
    typealias Input = (username: String, nickname: String, password: String)
    typealias Output = Result<Void, ValidationError>
    
    private let userEntityRepository: UserEntityRepositoryProtocol
    
    init(userEntityRepository: UserEntityRepositoryProtocol) {
        self.userEntityRepository = userEntityRepository
    }
    
    /// 새로운 사용자 데이터를 받아 검증 후 UserEntity에 저장.
    ///
    /// - Parameters:
    ///   - input: 사용자 입력 정보 (`Input` 타입)으로, 아래의 세 가지 정보를 포함합니다:
    ///     - **username** (`String`): 사용자가 입력한 이메일로 고유 아이디로 사용됩니다.
    ///     - **nickname** (`String`): 사용자가 입력한 별명이며, 중복을 허용합니다.
    ///     - **password** (`String`): 사용자가 입력한 비밀번호입니다.
    /// - Returns:
    ///   성공적으로 사용자 생성이 완료되면 `Void`를 반환합니다.
    ///   실패한 경우, `ValidationError`를 포함한 에러가 반환됩니다.
    func execute(_ input: Input) -> Output {
        var errors: [String] = [] // alert에서 띄워줄 가입 실패 원인 전달용.
        let (username, nickname, password) = input

        
        // 1. email 유효성 검사
        let usernameValidation = UsernameValidator.validate(username)
        switch usernameValidation {
        case .success:
            print("사용자 이름 유효성 검사 성공")
        case .failure(let error):
            print("사용자 이름 유효성 검사 실패: \(error)")
            
            errors.append(contentsOf: error.messages)
            return .failure(ValidationError(messages: errors))
        }
        
        // 2. email 중복검사
        if let _ = userEntityRepository.fetchUser(by: username) {
            print("사용자 이름 중복 검사 실패")
            
            errors.append("해당 이름은 사용할 수 없습니다.")
            return .failure(ValidationError(messages: errors))
        }
        
        // 3. nickname 유효성 검사
        let nicknameValidation = NicknameValidator.validate(nickname)
        switch nicknameValidation {
        case .success:
            print("사용자 별명 유효성 검사 성공")
        case .failure(let error):
            print("사용자 별명 유효성 검사 실패: \(error)")
            
            errors.append(contentsOf: error.messages)
            return .failure(ValidationError(messages: errors))
        }
        
        // 4. 패스워드 유효성 검사
        let passwordValidation = UserPasswordValidator.validate(password)
        switch passwordValidation {
        case .success:
            print("사용자 암호 유효성 검사 성공")
        case .failure(let error):
            print("사용자 암호 유효성 검사 실패: \(error)")
            
            errors.append(contentsOf: error.messages)
            return .failure(ValidationError(messages: errors))
        }
       
        // 5. 암호 해쉬화
        do {
            let hashedPw: String = try PasswordManager.encryptPassword(password)
            
            // 6. 사용자 생성
            guard let _ = userEntityRepository.createUser(username: username, nickname: nickname, hashedPw: hashedPw) else {
                print("왜인지 모르겠지만 아무튼 사용자 생성에 실패")
                
                errors.append("사용자 생성에 실패하였습니다.")
                return .failure(ValidationError(messages: errors))
            }
            
            print("성공!")
            
        } catch {
            print("패스워드 암호화 및 저장에 실패하였습니다. \(error)")
            
            errors.append("패스워드 암호화 및 저장에 실패하였습니다.")
            return .failure(ValidationError(messages: errors))
        }
       
        return .success(())
    }
}
