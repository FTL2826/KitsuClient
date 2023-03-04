//
//  SignInViewModel.swift
//  KitsuClient
//
//  Created by Александр Харин on /282/23.
//

import Foundation

class SignInViewModel: SignInViewModelProtocol {
    
    
    var passwordVerification: PasswordVerificationProtocol?
    var loginStatus = Dynamic("")
    var textColor = Dynamic(TextColor.red)
    var signInButtonValidation = Dynamic(false)
    
    init(passwordVerification: PasswordVerificationProtocol)
    {
        self.passwordVerification = passwordVerification
    }
    
    func didSignInPressed(email: String, password: String) {
        guard let passwordVerification = passwordVerification,
              passwordVerification.users.contains(where: {$0.email == email && $0.password == password})
        else {
            loginStatus.value = "Invalid username or password. Try again"
            textColor.value = .red
            return }

            loginStatus.value = "You succesfully sign in"
            textColor.value = .green
    }
    
    func validateTextFields(email: String?, password: String?) {
        guard let email = email, let password = password else {
            signInButtonValidation.value = false
            return
        }
        
        if !email.isEmpty && !password.isEmpty {
            signInButtonValidation.value = true
        } else {
            signInButtonValidation.value = false
        }
    }
    
}
