//
//  Login.swift
//  KitsuClient
//
//  Created by Александр Харин on /243/23.
//

import Foundation

struct Login: Codable {
    let string: String
    
    init?(_ rawString: String) {
        guard !rawString.isEmpty else { return nil }
        string = rawString
    }
}
