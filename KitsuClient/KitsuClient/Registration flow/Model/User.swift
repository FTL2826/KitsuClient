//
//  User.swift
//  KitsuClient
//
//  Created by Александр Харин on /282/23.
//

import Foundation

struct User: Codable {
    let login: String
    let email: String
    var password: String
    
    let llogin: Login?
    let credentials: Credentials?
}

