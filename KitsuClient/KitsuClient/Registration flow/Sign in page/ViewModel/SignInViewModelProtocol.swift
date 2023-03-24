//
//  SignInViewModelProtocol.swift
//  KitsuClient
//
//  Created by Александр Харин on /23/23.
//

import Combine


enum TextColor {
    case red, green
}


protocol SignInViewModelProtocol: AnyObject {
    
    var passwordVerification: PasswordVerificationProtocol { get }
    
    var loginStatusLabelHidden: CurrentValueSubject<Bool, Never> { get }
    var signInButtonValidation: CurrentValueSubject<Bool, Never> { get }
    var userData: PassthroughSubject<User, Never> { get }
    
    func didPressedSignInButton(emailString: String, passwordString: String)
    func validateTextFields(email: String?, password: String?)
}
