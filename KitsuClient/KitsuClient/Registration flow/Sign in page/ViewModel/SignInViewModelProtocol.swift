//
//  SignInViewModelProtocol.swift
//  KitsuClient
//
//  Created by Александр Харин on /23/23.
//


enum TextColor {
    case red, green
}


protocol SignInViewModelProtocol: AnyObject {
    
    var passwordVerification: PasswordVerificationProtocol? { get set }
    var loginStatus: Dynamic<String> { get set }
    var textColor: Dynamic<TextColor> { get set }
    var signInButtonValidation: Dynamic<Bool> { get set }
    
    func didSignInPressed(email: String, password: String)
    func validateTextFields(email: String?, password: String?)
}
