//
//  PasswordVerificationMock.swift
//  KitsuClientTests
//
//  Created by Александр Харин on /143/23.
//

import Foundation
@testable import KitsuClient

class PasswordVerificationMock: PasswordVerificationProtocol {
    
    var users: [KitsuClient.User] = []
    
    func loadUsers() {
        print("load")
    }
    
    
}
