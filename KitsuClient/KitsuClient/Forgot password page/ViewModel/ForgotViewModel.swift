//
//  ForgotViewModel.swift
//  KitsuClient
//
//  Created by Александр Харин on /33/23.
//

import Foundation

class ForgotViewModel: ForgotViewModelProtocol {
    
    var loginStatus = Dynamic("")
    var textColor = Dynamic(TextColor.red)
    var forgotPasswordButtonValidation = Dynamic(false)
    
    func didPressedResetPasswordButton(login: String?) {
        guard let login = login, login == User.logins[0].login else {
            loginStatus.value = "There are no accounts with this login. Please try again."
            textColor.value = .red
            return }
        loginStatus.value = "We succesfully reset your password. You should recieve a new password on email"
        // notification with new pass
        textColor.value = .green
    }
    
    func validateTextFields(login: String?) {
        guard let login = login, !login.isEmpty else {
            forgotPasswordButtonValidation.value = false
            return }
        forgotPasswordButtonValidation.value = true
    }
    
    
}
