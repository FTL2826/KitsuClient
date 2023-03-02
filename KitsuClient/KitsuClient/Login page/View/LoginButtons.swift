//
//  LoginButtons.swift
//  KitsuClient
//
//  Created by Александр Харин on /13/23.
//

import UIKit

class LoginButtons: UIButton {

    enum FontSize {
        case big
        case medium
        case small
    }
    
    init(title: String, background: UIColor, titleColor: UIColor, fontSize: FontSize) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        layer.cornerRadius = 12
        layer.masksToBounds = true
        
        backgroundColor = background
        setTitleColor(titleColor, for: .normal)
        
        switch fontSize {
        case .big:
            titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        case .medium:
            titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        case .small:
            titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
