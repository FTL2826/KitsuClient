//
//  LoginView.swift
//  KitsuClient
//
//  Created by Александр Харин on /282/23.
//

import Foundation
import UIKit

class LoginView: UIView {
    
    private var isExpand: Bool = false
    
    
    private lazy var signInLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Sign in"
        l.numberOfLines = 1
        l.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        l.textAlignment = .center
        l.textColor = .label
        return l
    }()
    private lazy var logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "loginLogo")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var loginLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Login"
        l.numberOfLines = 1
        l.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        l.textAlignment = .left
        l.textColor = .label
        l.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)
        l.setContentHuggingPriority(UILayoutPriority(251), for: .vertical)
        l.setContentCompressionResistancePriority(UILayoutPriority(750), for: .horizontal)
        l.setContentCompressionResistancePriority(UILayoutPriority(750), for: .vertical)
        return l
    }()
    
    private lazy var loginTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.textAlignment = .left
        tf.textColor = .label
        tf.placeholder = "Enter login here"
        tf.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        tf.backgroundColor = UIColor(named: "TextFieldBackground")
        tf.layer.cornerRadius = 5
        tf.setContentHuggingPriority(UILayoutPriority(48), for: .horizontal)
        tf.setContentHuggingPriority(UILayoutPriority(250), for: .vertical)
        tf.setContentCompressionResistancePriority(UILayoutPriority(749), for: .horizontal)
        tf.setContentCompressionResistancePriority(UILayoutPriority(750), for: .vertical)
        return tf
    }()
    
    private lazy var passwordLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Password"
        l.numberOfLines = 1
        l.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        l.textAlignment = .left
        l.textColor = .label
        l.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)
        l.setContentHuggingPriority(UILayoutPriority(251), for: .vertical)
        l.setContentCompressionResistancePriority(UILayoutPriority(750), for: .horizontal)
        l.setContentCompressionResistancePriority(UILayoutPriority(750), for: .vertical)
        return l
    }()
    
    private lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.textAlignment = .left
        tf.textColor = .label
        tf.placeholder = "Enter password here"
        tf.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        tf.backgroundColor = UIColor(named: "TextFieldBackground")
        tf.layer.cornerRadius = 5
        tf.setContentHuggingPriority(UILayoutPriority(48), for: .horizontal)
        tf.setContentHuggingPriority(UILayoutPriority(250), for: .vertical)
        tf.setContentCompressionResistancePriority(UILayoutPriority(749), for: .horizontal)
        tf.setContentCompressionResistancePriority(UILayoutPriority(750), for: .vertical)
        return tf
    }()
    private lazy var loginButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        return b
    }()
    
    //MARK: - Stacks
    private lazy var loginHStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fill
        stack.alignment = .firstBaseline
        
        stack.addArrangedSubview(loginLabel)
        stack.addArrangedSubview(loginTextField)
        return stack
    }()
    private lazy var passwordHStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fill
        stack.alignment = .firstBaseline
        
        stack.addArrangedSubview(passwordLabel)
        stack.addArrangedSubview(passwordTextField)
        return stack
    }()
    private lazy var inputFieldsVStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 8
        
        stack.addArrangedSubview(loginHStack)
        stack.addArrangedSubview(passwordHStack)
        return stack
    }()
    private lazy var logoHStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 0
        stack.distribution = .equalCentering
        stack.alignment = .center
        stack.addArrangedSubview(logoImageView)
        return stack
    }()
    
    
    private lazy var mainVStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    
    lazy var scroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(mainVStack)
        scroll.keyboardDismissMode = .onDragWithAccessory
        return scroll
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setNotificationForKeyboard()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("LoginView was destroyed")
    }
    
    //MARK: - Keyboard Notifications
    private func setNotificationForKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppearance(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc private func keyboardAppearance(notification: NSNotification){
        if !isExpand {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardHeight = keyboardFrame.cgRectValue.height
                scroll.contentSize = CGSize(width: self.frame.width, height: scroll.frame.height + keyboardHeight)
                scroll.scrollRectToVisible(CGRect(x: 0, y: keyboardHeight, width: self.frame.width, height: scroll.frame.height), animated: true)
            } else {
                scroll.contentSize = CGSize(width: self.frame.width, height: scroll.frame.height + 250)
            }
            isExpand = true
        }
    }

    @objc private func keyboardDisappear(notification: NSNotification) {
        if isExpand{
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardHeight = keyboardFrame.cgRectValue.height
                scroll.contentSize = CGSize(width: self.frame.width, height: scroll.frame.height - keyboardHeight)
            } else {
                scroll.contentSize = CGSize(width: self.frame.width, height: scroll.frame.height - 250)
            }
            isExpand = false
        }
    }
    
    //MARK: - Buttons targets
    @objc private func loginTapped() {
        
    }
    
    //MARK: - SetupUI
    private func setupUI() {
        backgroundColor = .systemBackground
        
        addSubview(scroll)
        
        mainVStack.addArrangedSubview(logoHStack)
        mainVStack.addArrangedSubview(signInLabel)
        mainVStack.addArrangedSubview(inputFieldsVStack)
        
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            
            mainVStack.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            mainVStack.centerYAnchor.constraint(equalTo: scroll.centerYAnchor),
            mainVStack.widthAnchor.constraint(equalTo: scroll.widthAnchor, multiplier: 0.8),
    
            
            
            loginTextField.widthAnchor.constraint(equalTo: passwordTextField.widthAnchor),
        ])
        
    }
    
    
    
}
