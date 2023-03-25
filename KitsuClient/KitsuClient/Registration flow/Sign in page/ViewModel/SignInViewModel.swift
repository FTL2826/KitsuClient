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
    
    var emailTextFieldValue = PassthroughSubject<String, Never>()
    var passwordTextFieldValue = PassthroughSubject<String, Never>()
    var signInButtonEnable = CurrentValueSubject<Bool, Never>(false)
    var loginStatusValue = PassthroughSubject<String, Never>()
    var loginStatusLabelHidden = CurrentValueSubject<Bool, Never>(true)
    
    var signInButtonValidation = CurrentValueSubject<Bool, Never>(false)
    var userData = PassthroughSubject<User, Never>()
    
    var credentials: Credentials?
    var subscriptions = Set<AnyCancellable>()
    
    init(passwordVerification: PasswordVerificationProtocol)
    {
        self.passwordVerification = passwordVerification
        
        Publishers.CombineLatest(emailTextFieldValue, passwordTextFieldValue)
            .receive(on: DispatchQueue.global())
            .sink { (emailString, passwordString) in
                self.signInButtonEnable.send(false)
                self.validateInput(emailString, passwordString)
            }.store(in: &subscriptions)
    }
    
    private func validateInput(_ emailString: String, _ passwordString: String) {
        guard let email = Email(emailString)
        else {
            loginStatusValue.send("Incorrect form of email, try enter it again")
            loginStatusLabelHidden.send(false)
            return
        }
        let password = Password.parse(passwordString)
        switch password {
        case .success(let password):
            loginStatusLabelHidden.send(true)
            credentials = Credentials(email: email, password: password)
            signInButtonEnable.send(true)
        case .failure(_):
            loginStatusValue.send("Incorrect form of password, try enter it again")
            loginStatusLabelHidden.send(false)
        }
    }
    
    func didPressedSignInButton() {
        guard let credentials = credentials else { return }
        do {
            let user = try passwordVerification.checkCredentials(credentials)
            userData.send(user)
        } catch {
            loginStatusValue.send("Wrong email or password, please try again")
            loginStatusLabelHidden.send(false)
        }
    }
    
    
    
}
