//
//  Password.swift
//  KitsuClient
//
//  Created by Александр Харин on /243/23.
//

import Foundation

struct Password: Codable, Equatable {
    let string: String
    
    private init(string: String) {
        self.string = string
    }
    
    enum ValidationError: Error {
        case tooShort
    }
    
    static func parse(_ rawString: String) -> Result<Password, ValidationError> {
        guard rawString.count > 3 else {
            return .failure(.tooShort)
        }
        return .success(Password(string: rawString))
    }
    
}
