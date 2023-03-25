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
    
    var emailTextFieldValue: PassthroughSubject<String, Never> { get }
    var passwordTextFieldValue: PassthroughSubject<String, Never> { get }
    var signInButtonEnable: CurrentValueSubject<Bool, Never> { get }
    var loginStatusValue: PassthroughSubject<String, Never> { get }
    var loginStatusLabelHidden: CurrentValueSubject<Bool, Never> { get }
    
    var signInButtonValidation: CurrentValueSubject<Bool, Never> { get }
    var userData: PassthroughSubject<User, Never> { get }
    
    func didPressedSignInButton()
}
