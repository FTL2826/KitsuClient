//
//  SignUpViewController.swift
//  KitsuClient
//
//  Created by Александр Харин on /23/23.
//

import UIKit

class SignUpViewController: UIViewController {
    
    weak var viewModel: SignUpViewModelProtocol?
    weak var coordinator: RegistrationFlowCoordinatorProtocol?
    
    private var views: [UIView] = []
    private var headerView: LoginHeaderView!
    private var loginTextField: InputTextField!
    private var emailTextField: InputTextField!
    private var passwordTextField: InputTextField!
    private var signUpButton: LoginButtons!
    private var signInButton: LoginButtons!
    
    
    init(viewModel: SignUpViewModelProtocol,
         coordinator: RegistrationFlowCoordinatorProtocol)
    {
        super.init(nibName: nil, bundle: nil)
        
        self.coordinator = coordinator
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func loadView() {
        createSubViews()
        
        super.loadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setupUI()
    }
    
    private func bindViewModel() {
        
    }
    
    private func createSubViews() {
        headerView = LoginHeaderView(title: "Sign Up", subtitle: "Create your account!")
        
        loginTextField = InputTextField(fieldType: .userName)
        loginTextField.delegate = self
        loginTextField.tag = 101
        emailTextField = InputTextField(fieldType: .email)
        emailTextField.delegate = self
        emailTextField.tag = 102
        passwordTextField = InputTextField(fieldType: .password)
        passwordTextField.delegate = self
        passwordTextField.tag = 103
        
        signUpButton = LoginButtons(title: "Sign Up", background: .systemBlue, titleColor: .white, fontSize: .big)
        signInButton = LoginButtons(title: "Already have an account? Sign in.", background: .clear, titleColor: .systemBlue, fontSize: .medium)
        
        views = [headerView,
                 loginTextField,
                 emailTextField,
                 passwordTextField,
                 signUpButton,
                 signInButton,
        ]
    }
    
    private func initializeHideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    private func addTargets() {
        signInButton.addTarget(self, action: #selector(didTapSignInButton), for: .touchUpInside)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        initializeHideKeyboard()
        addTargets()
        
        views.forEach{
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 200),
            
            loginTextField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            loginTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            loginTextField.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.85),
            loginTextField.heightAnchor.constraint(equalToConstant: 45),
            
            emailTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 10),
            emailTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emailTextField.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.85),
            emailTextField.heightAnchor.constraint(equalToConstant: 45),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
            passwordTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.85),
            passwordTextField.heightAnchor.constraint(equalToConstant: 45),
            
            signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            signUpButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            signUpButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.85),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            
            signInButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 6),
            signInButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            signInButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.85),
            signInButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
    }
    
    //MARK: - selectors
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func didTapSignInButton() {
        self.dismiss(animated: true)
    }

}


extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = view.viewWithTag(textField.tag + 1) as? InputTextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return false
    }
    
}
