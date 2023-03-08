//
//  SignUpViewModelProtocol.swift
//  KitsuClient
//
//  Created by Александр Харин on /23/23.
//

import Foundation

protocol SignUpViewModelProtocol: AnyObject {
    
    var passwordVerification: PasswordVerificationProtocol? { get set }
    var signUpButtonValidation: Dynamic<Bool> { get set }
    var uniqEmail: Dynamic<Bool> { get set }
    
    func validateTextFields(login: String?, email: String?, password: String?)
    func didPressedSignUpButton(login: String?, email: String?, password: String?)
    
    
}
