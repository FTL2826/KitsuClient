//
//  SignUpViewModel.swift
//  KitsuClient
//
//  Created by Александр Харин on /23/23.
//

import Foundation


class SignUpViewModel: SignUpViewModelProtocol {
    
    var signUpButtonValidation = Dynamic(false)
    
    func validateTextFields(login: String?, email: String?, password: String?) {
        guard let login = login, let email = email, let password = password else { return }
        
        if !login.isEmpty && !email.isEmpty && !password.isEmpty {
            signUpButtonValidation.value = true
        } else {
            signUpButtonValidation.value = false
        }
    }
    
    
}
