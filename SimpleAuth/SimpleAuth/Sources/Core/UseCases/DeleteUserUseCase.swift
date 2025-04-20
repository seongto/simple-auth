//
//  DeleteUserUseCase.swift
//  SimpleAuth
//
//  Created by MaxBook on 4/20/25.
//

import Foundation


/// 사용자 탈퇴 UseCase
///
/// - execute(_:) : 사용자 탈퇴 실행하는 메서드
struct DeleteUserUseCase: UseCaseProtocol {
    typealias Input = String
    typealias Output = Result<Bool, ValidationError>
    
    private let userEntityRepository: UserEntityRepositoryProtocol
    
    init(userEntityRepository: UserEntityRepositoryProtocol) {
        self.userEntityRepository = userEntityRepository
    }
    
    /// 사용자 데이터를 받아 검증 후 로그인 처리
    ///
    /// - Parameters:
    ///   - input: 사용자 입력 정보 (`Input` 타입)으로, 아래의 정보를 포함합니다:
    ///     - **username** (`String`): 사용자의 username. 이메일.
    /// - Returns:
    ///   성공적으로 사용자 로그인이 완료되면 `true`를 반환합니다.
    ///   실패한 경우, `ValidationError`를 포함한 에러가 반환됩니다.
    func execute(_ input: Input) -> Output {
        var errors: [String] = [] // alert에서 띄워줄 가입 실패 원인 전달용.
        let username = input
        
        do {
            // 해당 아이디를 가진 사용자가 존재하는 지 확인
            guard let targetUser = userEntityRepository.fetchUser(by: username) else {
                errors.append("사용자 정보가 없습니다.")
                return .failure(ValidationError(messages: errors))
            }
            
            userEntityRepository.deleteUser(user: targetUser)
            
            print("탈퇴 성공")
            return .success(true)
        }
    }
}
