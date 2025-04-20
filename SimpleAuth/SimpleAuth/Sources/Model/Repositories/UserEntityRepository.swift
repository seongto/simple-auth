//
//  UserRepository.swift
//  SimpleAuth
//
//  Created by MaxBook on 4/19/25.
//

import Foundation
import CoreData

protocol UserEntityRepositoryProtocol {
    func createUser(username: String, nickname: String, hashedPw: String) -> UserEntity?
    func fetchUser(by username: String) -> UserEntity?
    func fetchAllUsers() -> [UserEntity]
    func deleteUser(user: UserEntity)
    func getAuthenticatedUser(username: String, hashedPw: String) -> UserEntity?
}


final class UserEntityRepository: UserEntityRepositoryProtocol {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }
    
    /// coredata에 수정사항을 반영하기
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("context save에 실패하였습니다. : \(error)")
        }
    }
    
    
    // MARK: - CRUD
    
    /// 새로운 사용자 생성
    /// - Parameters:
    ///   - username: 사용자의 이용아이디 이메일. 고유값을 가진다.
    ///   - password: 문자열로 받아 이를 해쉬화암호로 변경하고 저장
    /// - Returns: 새로운 사용자 생성 후 해당 사용자 객체를 리턴.
    func createUser(username: String, nickname: String, hashedPw: String) -> UserEntity? {
        let newUser = UserEntity(context: context)
        
        newUser.username = username
        newUser.hashedPassword = hashedPw
        newUser.nickname = nickname
        
        // 6-1. 저장하기
        saveContext()
        
        // 6-2. 이메일로 검색해서 정보 가져오기 : 제대로 저장되었는지 판단하고 암호 제외한 값을 반한.
        let fetchedUser = fetchUser(by: username)
        
        return fetchedUser
    }
    
    /// username이 일치하는 사용자 정보 가져오기
    /// - Parameter username: 고유한 사용자의 이용아이디 dlapdlf
    /// - Returns: 입력한 아이디와 일치하는 UserEntity 객체를 반환. username,만 가져온다.
    func fetchUser(by username: String) -> UserEntity? {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", username as CVarArg)
        
        fetchRequest.resultType = .managedObjectResultType
        fetchRequest.propertiesToFetch = ["username", "nickname"]
        
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("사용자 정보가 없습니다. : \(error)")
            return nil
        }
    }
    
    
    /// 서비스의 모든 이용자 가져오기
    /// 가입이 정상적으로 이루어졌는지 테스트 용.
    ///
    /// - Returns: 모든 이용자의 이름 가져오기.
    func fetchAllUsers() -> [UserEntity] {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.resultType = .managedObjectResultType
        fetchRequest.propertiesToFetch = ["username", "nickname"]

        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("사용자 정보가 없습니다. :\(error)")
            return []
        }
    }
    
    /// 사용자 정보를 삭제
    /// - Parameter user: 삭제하고자 하는 사용자
    func deleteUser(user: UserEntity) {
        context.delete(user)
        saveContext()
    }
    
    /// 사용자 로그인 확인
    /// - Parameters:
    ///   - username: 사용자가 입력한 이메일 아이디
    ///   - hashedPw: 사용자가 입력한 비밀번호를 해쉬화한 암호
    /// - Returns: 정상적으로 확인 시 해당하는 사용자 정보 반환. 없을 경우 nil 반환.
    func getAuthenticatedUser(username: String, hashedPw: String) -> UserEntity? {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "username == %@ AND hashedPassword == %@",
            username as CVarArg, hashedPw as CVarArg
        )
        
        fetchRequest.resultType = .managedObjectResultType
        fetchRequest.propertiesToFetch = ["username", "nickname"]
        
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("인증 중 오류 발생: \(error)")
            return nil
        }
    }
}

