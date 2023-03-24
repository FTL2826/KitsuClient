//
//  SignUpViewModelProtocol.swift
//  KitsuClient
//
//  Created by Александр Харин on /23/23.
//

import Foundation
import Combine

protocol SignUpViewModelProtocol: AnyObject {
    
    var passwordVerification: PasswordVerificationProtocol? { get set }
    var signUpButtonValidation: Dynamic<Bool> { get set }
    var uniqEmail: Dynamic<Bool> { get set }
    
    var loginTextFieldValue: PassthroughSubject<String, Never> { get set }
    var emailTextFieldValue: PassthroughSubject<String, Never> { get set }
    var passwordTextFieldValue: PassthroughSubject<String, Never> { get set }
    
    func validateTextFields(login: String?, email: String?, password: String?)
    func didPressedSignUpButton(login: String?, email: String?, password: String?)
    
    
}
