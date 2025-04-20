//
//  UserEntity+CoreDataProperties.swift
//  SimpleAuth
//
//  Created by MaxBook on 4/20/25.
//
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var username: String?
    @NSManaged public var hashedPassword: String?
    @NSManaged public var nickname: String?

}

extension UserEntity : Identifiable {

}
