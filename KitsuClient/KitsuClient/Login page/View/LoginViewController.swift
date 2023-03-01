//
//  LoginViewController.swift
//  KitsuClient
//
//  Created by Александр Харин on /282/23.
//

import UIKit

class LoginViewController: UIViewController {
    
    private var views: [UIView] = []
    private var loginHeaderView: LoginHeaderView!
    private var loginTextField: InputTextField!
    private var passwordTextField: InputTextField!
    
    override func loadView() {
        loginHeaderView = LoginHeaderView(title: "Sigh In", subtitle: "Sign in to your account")
        loginTextField = InputTextField(fieldType: .userName)
        passwordTextField = InputTextField(fieldType: .password)
        super.loadView()
        views = [loginHeaderView, loginTextField, passwordTextField]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    

    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        views.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            loginHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            loginHeaderView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            loginHeaderView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            loginHeaderView.heightAnchor.constraint(equalToConstant: 180),
            
            loginTextField.topAnchor.constraint(equalTo: loginHeaderView.bottomAnchor, constant: 20),
            loginTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            loginTextField.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.85),
            loginTextField.heightAnchor.constraint(equalToConstant: 55),
            
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 20),
            passwordTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.85),
            passwordTextField.heightAnchor.constraint(equalToConstant: 55),
        ])
    }
    
    
}

