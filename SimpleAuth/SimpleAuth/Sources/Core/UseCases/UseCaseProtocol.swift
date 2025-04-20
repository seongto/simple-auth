//
//  UseCaseProtocol.swift
//  SimpleAuth
//
//  Created by MaxBook on 4/19/25.
//
//

import Foundation

protocol UseCaseProtocol {
    associatedtype Input
    associatedtype Output
    
    func execute(_ input: Input) -> Output
}
