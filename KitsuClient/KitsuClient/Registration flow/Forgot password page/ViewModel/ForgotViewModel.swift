//
//  ForgotViewModel.swift
//  KitsuClient
//
//  Created by Александр Харин on /33/23.
//

import Foundation
import Combine

class ForgotViewModel: ForgotViewModelProtocol {
    
    
    var passwordVerification: PasswordVerificationProtocol
    
    var emailTextFieldValue = PassthroughSubject<String, Never>()
    var resetPasswordButtonEnable = CurrentValueSubject<Bool, Never>(false)
    var resetPasswordStatusLabelHidden = PassthroughSubject<Bool, Never> ()
    var resetPasswordStatusLabelValue = PassthroughSubject<String, Never>()
    var makeStatusLabelGreen = PassthroughSubject<Bool, Never>()
    
    var subscriptions = Set<AnyCancellable>()
    var email: Email?
    
    init(passwordVerification: PasswordVerificationProtocol)
    {
        self.passwordVerification = passwordVerification
        
        emailTextFieldValue
            .receive(on: DispatchQueue.global())
            .sink {[unowned self] emailString in
                self.resetPasswordButtonEnable.send(false)
                self.makeStatusLabelGreen.send(false)
                self.validateEmail(emailString)
            }.store(in: &subscriptions)
    }
    
    private func validateEmail(_ emailString: String) {
        guard let email = Email(emailString)
        else {
            resetPasswordStatusLabelHidden.send(false)
            resetPasswordStatusLabelValue.send("Incorrect form of email, please try enter it again.")
            return
        }
        self.email = email
        resetPasswordStatusLabelHidden.send(true)
        resetPasswordButtonEnable.send(true)
    }
    
    func didPressedResetPasswordButton() {
        guard let email = email else { return }
        do {
            try passwordVerification.dropPasswordToDefault(email)
            resetPasswordStatusLabelValue.send("We successfully reset your password and send new one on your email.")
            makeStatusLabelGreen.send(true)
            resetPasswordStatusLabelHidden.send(false)
            resetPasswordButtonEnable.send(false)
        } catch {
            resetPasswordStatusLabelValue.send("Error occure while we trying to reset your password. Check your email spelling or contact with tech support team.")
            resetPasswordStatusLabelHidden.send(false)
            makeStatusLabelGreen.send(false)
        }
    }
    
}
