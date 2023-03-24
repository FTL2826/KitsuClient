//
//  PasswordVerification.swift
//  KitsuClient
//
//  Created by Александр Харин on /43/23.
//

import Foundation

class PasswordVerification: PasswordVerificationProtocol {
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    var users: [User] {
        didSet {
            saveUsers()
        }
    }
    
    enum UserVerificationError: Error {
        case alreadyRegistered
    }
    
    init() {
        if let data = UserDefaults.standard.data(forKey: UserDefaultsKeys.users) {
            do {
                self.users = try decoder.decode([User].self, from: data)
            } catch {
                print("Decode error:", " coudn't decode extracted users. \n\(error)")
                self.users = []
            }
        } else {
            self.users = []
        }
        
    }
    
    func loadUsers() {
        if let data = UserDefaults.standard.data(forKey: UserDefaultsKeys.users) {
            do {
                self.users = try decoder.decode([User].self, from: data)
            } catch {
                print("Decode error:", " coudn't decode extracted users. \n\(error)")
            }
        }
    }
    
    private func saveUsers() {
        do {
            let data = try encoder.encode(users)
            UserDefaults.standard.set(data, forKey: UserDefaultsKeys.users)
        } catch {
            print("Encode error:", " unable to encode [User]. \n\(error)")
        }
    }
    
    func addUser(_ user: User) throws {
        
    }
    
    
}
