//
//  SignInViewModel.swift
//  KitsuClient
//
//  Created by Александр Харин on /282/23.
//

import Foundation
import Combine

class SignInViewModel: SignInViewModelProtocol {
    
    var passwordVerification: PasswordVerificationProtocol
    var loginStatusLabelHidden = CurrentValueSubject<Bool, Never>(true)
    var signInButtonValidation = CurrentValueSubject<Bool, Never>(false)
    var userData = PassthroughSubject<User, Never>()
    var completionHandler: ((User) -> ())?
    
    init(passwordVerification: PasswordVerificationProtocol)
    {
        self.passwordVerification = passwordVerification
    }
    
    func didPressedSignInButton(emailString: String, passwordString: String) {
        guard let email = Email(emailString) else {
            loginStatusLabelHidden.send(false)
            return
        }

        let password = Password.parse(passwordString)
        switch password {
        case .success(let password):
            let credentials = Credentials(email: email, password: password)
            authorizeUser(with: credentials)
        case .failure(let error):
            loginStatusLabelHidden.send(false)
            print("Password validation error: \(error)")
        }
    }
    
    func validateTextFields(email: String?, password: String?) {
        signInButtonValidation.send(validateCredentialsText(email: email, password: password))
    }
    
    private func authorizeUser(with credentials: Credentials) {
        //check creedentials
        if credentials.password.string != "12345" {
            loginStatusLabelHidden.send(false)
        } else {
            loginStatusLabelHidden.send(true)
        }
        userData.send(User(login: "admin", email: "admin@mail.com", password: "12345", llogin: nil, credentials: credentials))
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
