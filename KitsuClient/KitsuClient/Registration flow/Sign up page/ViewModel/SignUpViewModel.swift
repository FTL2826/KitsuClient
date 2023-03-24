//
//  SignUpViewModel.swift
//  KitsuClient
//
//  Created by Александр Харин on /23/23.
//

import Foundation
import Combine

class SignUpViewModel: SignUpViewModelProtocol {
    
    var passwordVerification: PasswordVerificationProtocol
    var signUpButtonValidation = Dynamic(false)
    var uniqEmail = Dynamic(true)
   
    var loginTextFieldValue = PassthroughSubject<String, Never>()
    var emailTextFieldValue = PassthroughSubject<String, Never>()
    var passwordTextFieldValue = PassthroughSubject<String, Never>()
    
    var subscriptions = Set<AnyCancellable>()
    
    init(passwordVerification: PasswordVerificationProtocol)
    {
        self.passwordVerification = passwordVerification
        
        Publishers.Zip3(loginTextFieldValue, emailTextFieldValue, passwordTextFieldValue)
            .receive(on: DispatchQueue.global())
            .sink {[unowned self] (loginString, emailString, passwordString) in
                self.validateUser(loginString, emailString, passwordString)
            }.store(in: &subscriptions)
    }
    
    private func validateUser(_ loginString: String, _ emailString: String, _ passwordString: String) {
        guard let login = Login(loginString),
              let email = Email(emailString) else { return }
        let password = Password.parse(passwordString)
        switch password {
        case .success(let password):
            
        case .failure(let error):
            print("password error in SignUpViewModel: \(error)")
        }
    }
    
    func validateTextFields(login: String?, email: String?, password: String?) {
        guard let login = login, let email = email, let password = password else { return }
        
        if passwordVerification.users.contains(where: {$0.email == email}) {
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
                let password = password
        else { return }
        
        if passwordVerification.users.contains(where: {$0.email == email}) {
            uniqEmail.value = false
        } else if !passwordVerification.users.contains(where: {$0.login == login && $0.password == password && $0.email == email}) {
            uniqEmail.value = true
            passwordVerification.users.append(
                User(login: login, email: email, password: password, llogin: nil, credentials: nil))
        }
        
    }
    
    
}
