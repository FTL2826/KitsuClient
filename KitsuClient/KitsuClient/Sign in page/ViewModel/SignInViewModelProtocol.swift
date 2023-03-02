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
    
    var loginStatus: Dynamic<String> { get set }
    var textColor: Dynamic<TextColor> { get set }
    var signInButtonValidation: Dynamic<Bool> { get set }
    
    func didSignInPressed(login: String, password: String)
    func validateTextFields(login: String?, password: String?)
}
