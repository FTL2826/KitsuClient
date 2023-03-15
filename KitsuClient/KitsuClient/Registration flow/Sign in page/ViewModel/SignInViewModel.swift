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
    var loginStatusLabelHidden = Dynamic(true)
    var textColor = Dynamic(TextColor.red)
    var signInButtonValidation = Dynamic(false)
    var completionHandler: ((User) -> ())?
    
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
            loginStatusLabelHidden.value = false
            return }

        loginStatusLabelHidden.value = true
        
        let userIndex = passwordVerification.users.firstIndex(where: {$0.email == email})!
        completionHandler?(passwordVerification.users[userIndex])
    }
    
    func validateTextFields(email: String?, password: String?) {
        signInButtonValidation.value = validateCredentialsText(email: email, password: password)
    }
    
    func validateCredentialsText(email: String?, password: String?) -> Bool {
        guard let email = email,
              let password = password,
              !email.isEmpty,
              !password.isEmpty else {
            return false
        }
        return true
    }
    
    
}
