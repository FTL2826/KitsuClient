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
   
    var uniqEmailStatus = PassthroughSubject<String, Never>()
    var uniqEmailStatusHidden = PassthroughSubject<Bool, Never>()
    var signUpButtonEnable = CurrentValueSubject<Bool, Never>(false)
    var goToSignInScreen = PassthroughSubject<Bool, Never>()
    
    var loginTextFieldValue = PassthroughSubject<String, Never>()
    var emailTextFieldValue = PassthroughSubject<String, Never>()
    var passwordTextFieldValue = PassthroughSubject<String, Never>()
    
    var user: User?
    
    var subscriptions = Set<AnyCancellable>()
    
    init(passwordVerification: PasswordVerificationProtocol)
    {
        self.passwordVerification = passwordVerification
        
        Publishers.CombineLatest3(loginTextFieldValue, emailTextFieldValue, passwordTextFieldValue)
            .receive(on: DispatchQueue.global())
            .sink {[unowned self] (loginString, emailString, passwordString) in
                self.signUpButtonEnable.send(false)
                self.validateUser(loginString, emailString, passwordString)
            }.store(in: &subscriptions)
    }
    
    private func validateUser(_ loginString: String, _ emailString: String, _ passwordString: String) {
        guard let login = Login(loginString),
              let email = Email(emailString)
        else {
            uniqEmailStatus.send("Incorrect login or email. Please try again")
            uniqEmailStatusHidden.send(false)
            return
        }
        
        let password = Password.parse(passwordString)
        switch password {
        case .success(let password):
            uniqEmailStatus.send("Correct data")
            uniqEmailStatusHidden.send(true)
            signUpButtonEnable.send(true)
            
            user = User(login: login, credentials: Credentials(email: email, password: password))
        case .failure(let error):
            uniqEmailStatus.send("Incorrect password, reason: \(error)")
            uniqEmailStatusHidden.send(false)
        }
    }
    
    func didPressedSignInButton() {
        goToSignInScreen.send(true)
    }
    
    func didPressedSignUpButton() {
        guard let user = user else { return }
        do {
            try passwordVerification.addUser(user)
            goToSignInScreen.send(true)
        } catch {
            print("User is already exist")
        }
        
    }
    
    
}
