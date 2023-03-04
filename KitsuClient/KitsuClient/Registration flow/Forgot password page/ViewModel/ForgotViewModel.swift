//
//  ForgotViewModel.swift
//  KitsuClient
//
//  Created by Александр Харин on /33/23.
//

import Foundation

class ForgotViewModel: ForgotViewModelProtocol {
    
    
    var passwordVerification: PasswordVerificationProtocol?
    var loginStatus = Dynamic("")
    var textColor = Dynamic(TextColor.red)
    var forgotPasswordButtonValidation = Dynamic(false)
    
    init(passwordVerification: PasswordVerificationProtocol)
    {
        self.passwordVerification = passwordVerification
    }
    
    func didPressedResetPasswordButton(email: String?) {
        guard let email = email,
              let userIndex = passwordVerification?.users.firstIndex(where: {$0.email == email})
        else {
            loginStatus.value = "There are no accounts with this email. Please try again."
            textColor.value = .red
            return
        }
        passwordVerification?.users[userIndex].password = "123"
        loginStatus.value = "We succesfully reset your password. You should recieve a new password on email"
        // notification with new pass
        textColor.value = .green
    }
    
    func validateTextFields(email: String?) {
        guard let email = email, !email.isEmpty else {
            forgotPasswordButtonValidation.value = false
            return }
        forgotPasswordButtonValidation.value = true
    }
    
    
}
