//
//  ForgotViewModelProtocol.swift
//  KitsuClient
//
//  Created by Александр Харин on /33/23.
//

import Foundation
import Combine


protocol ForgotViewModelProtocol: AnyObject {
    
    var passwordVerification: PasswordVerificationProtocol { get }
    
    var emailTextFieldValue: PassthroughSubject<String, Never> { get }
    var resetPasswordButtonEnable: CurrentValueSubject<Bool, Never> { get }
    var resetPasswordStatusLabelHidden: PassthroughSubject<Bool, Never> { get }
    var resetPasswordStatusLabelValue: PassthroughSubject<String, Never> { get }
    var makeStatusLabelGreen: PassthroughSubject<Bool, Never> { get }
    
    func didPressedResetPasswordButton()
}
