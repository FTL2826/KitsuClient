//
//  UITextField+Publisher.swift
//  KitsuClient
//
//  Created by Александр Харин on /243/23.
//

import Foundation
import UIKit.UITextField
import Combine

extension UITextField {
    
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(
            for: UITextField.textDidChangeNotification,
            object: self)
        .compactMap { ($0.object as? UITextField)?.text }
        .eraseToAnyPublisher()
    }
}
