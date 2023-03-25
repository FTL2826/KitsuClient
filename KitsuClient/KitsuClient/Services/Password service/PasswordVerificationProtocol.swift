//
//  PasswordVerificationProtocol.swift
//  KitsuClient
//
//  Created by Александр Харин on /43/23.
//

import Foundation

protocol PasswordVerificationProtocol {
    
    var users: [User] { get }
    
    func loadUsers()
    func addUser(_ user: User) throws
    func checkCredentials(_ credentials: Credentials) throws -> User
    
    func dropPasswordToDefault(_ email: Email) throws
}
