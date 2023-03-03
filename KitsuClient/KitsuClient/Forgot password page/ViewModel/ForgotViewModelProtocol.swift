//
//  ForgotViewModelProtocol.swift
//  KitsuClient
//
//  Created by Александр Харин on /33/23.
//

import Foundation


protocol ForgotViewModelProtocol: AnyObject {
    
    var loginStatus: Dynamic<String> { get set }
    var textColor: Dynamic<TextColor> { get set }
    var forgotPasswordButtonValidation: Dynamic<Bool> { get set }
    
    func didPressedResetPasswordButton(login: String?)
    func validateTextFields(login: String?)
}
