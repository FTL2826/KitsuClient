//
//  SignUpViewModelProtocol.swift
//  KitsuClient
//
//  Created by Александр Харин on /23/23.
//

import Foundation
import Combine

protocol SignUpViewModelProtocol: AnyObject {
    
    var passwordVerification: PasswordVerificationProtocol { get }
    
    var uniqEmailStatus: PassthroughSubject<String, Never> { get }
    var uniqEmailStatusHidden: PassthroughSubject<Bool, Never> { get }
    var signUpButtonEnable: CurrentValueSubject<Bool, Never> { get }
    var goToSignInScreen: PassthroughSubject<Bool, Never> { get }
    
    var loginTextFieldValue: PassthroughSubject<String, Never> { get }
    var emailTextFieldValue: PassthroughSubject<String, Never> { get }
    var passwordTextFieldValue: PassthroughSubject<String, Never> { get }
    
    func didPressedSignUpButton()
    func didPressedSignInButton()
    
}
