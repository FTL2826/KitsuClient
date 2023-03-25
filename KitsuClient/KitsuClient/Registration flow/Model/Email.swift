//
//  Email.swift
//  KitsuClient
//
//  Created by Александр Харин on /243/23.
//

import Foundation

struct Email: Codable, Equatable {
    let string: String
    
    init?(_ rawString: String) {
        guard !rawString.isEmpty,
              rawString.contains(where: { $0 == "@" })  else {
            return nil
        }
        string = rawString
    }
}
