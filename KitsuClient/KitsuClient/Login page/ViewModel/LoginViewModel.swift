//
//  LoginViewModel.swift
//  KitsuClient
//
//  Created by Александр Харин on /282/23.
//

import Foundation

class LoginViewModel {
    
    enum TextColor {
        case red, green
    }
    
    var loginStatus = Dynamic("")
    var textColor = Dynamic(TextColor.red)
    var signInButtonValidation = Dynamic(false)
    
    func didSignInPressed(login: String, password: String) {
        if login != User.logins[0].login || password != User.logins[0].password {
            loginStatus.value = "Invalid username or password. Try again"
            textColor.value = .red
        } else {
            loginStatus.value = "You succesfully sign in"
            textColor.value = .green
        }
    }
    
    func validateTextFields(login: String?, password: String?) {
        guard let login = login, let password = password else {
            signInButtonValidation.value = false
            return
        }
        
        if !login.isEmpty && !password.isEmpty {
            signInButtonValidation.value = true
        } else {
            signInButtonValidation.value = false
        }
    }
    
}
