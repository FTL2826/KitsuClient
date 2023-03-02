//
//  InputTextField.swift
//  KitsuClient
//
//  Created by Александр Харин on /13/23.
//

import UIKit

class InputTextField: UITextField {

    enum TextFieldsType {
        case userName
        case email
        case password
    }
    
    private let loginFieldType: TextFieldsType
    
    init(fieldType: TextFieldsType) {
        loginFieldType = fieldType
        super.init(frame: .zero)
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 10
        
        returnKeyType = .done
        autocorrectionType = .no
        autocapitalizationType = .none
        
        leftViewMode = .always
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: bounds.height))
        
        switch fieldType {
        case .userName:
            placeholder = "Username"
            keyboardType = .default
        case .email:
            placeholder = "Email address"
            keyboardType = .emailAddress
            textContentType = .emailAddress
        case .password:
            placeholder = "Password"
            textContentType = .oneTimeCode
            keyboardType = .numbersAndPunctuation
            isSecureTextEntry = true
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
