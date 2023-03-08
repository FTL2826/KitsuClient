//
//  PasswordVerificationProtocol.swift
//  KitsuClient
//
//  Created by Александр Харин on /43/23.
//

import Foundation

protocol PasswordVerificationProtocol {
    
    var users: [User] { get set }
    
    func loadUsers()
    
}
