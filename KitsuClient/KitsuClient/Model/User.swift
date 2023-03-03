//
//  User.swift
//  KitsuClient
//
//  Created by Александр Харин on /282/23.
//

import Foundation

struct User {
    let login: String
    let email: String
    let password: String
}

extension User {
    static var logins = [User(login: "guru", email: "example@mai.com", password: "123")]
}
