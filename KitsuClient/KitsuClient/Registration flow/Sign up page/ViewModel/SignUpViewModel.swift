//
//  SignUpViewModel.swift
//  KitsuClient
//
//  Created by Александр Харин on /23/23.
//

import Foundation


class SignUpViewModel: SignUpViewModelProtocol {
    
    var passwordVerification: PasswordVerificationProtocol?
    var signUpButtonValidation = Dynamic(false)
    var uniqEmail = Dynamic(true)
    
    init(passwordVerification: PasswordVerificationProtocol)
    {
        self.passwordVerification = passwordVerification
    }
    
    func validateTextFields(login: String?, email: String?, password: String?) {
        guard let login = login, let email = email, let password = password else { return }
        
        if passwordVerification!.users.contains(where: {$0.email == email}) {
            uniqEmail.value = false
            return
        } else {
            uniqEmail.value = true
        }
        
        if !login.isEmpty && !email.isEmpty && !password.isEmpty {
            signUpButtonValidation.value = true
        } else {
            signUpButtonValidation.value = false
        }
        
    }
    
    func didPressedSignUpButton(login: String?, email: String?, password: String?) {
        guard let login = login,
                let email = email,
                let password = password,
                passwordVerification != nil
        else { return }
        
        if passwordVerification!.users.contains(where: {$0.email == email}) {
            uniqEmail.value = false
        } else if !passwordVerification!.users.contains(where: {$0.login == login && $0.password == password && $0.email == email}) {
            uniqEmail.value = true
            passwordVerification!.users.append(
                User(login: login, email: email, password: password))
        }
        
    }
    
    
}
