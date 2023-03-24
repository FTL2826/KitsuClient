//
//  SignInViewController.swift
//  KitsuClient
//
//  Created by Александр Харин on /282/23.
//

import UIKit
import Combine

class SignInViewController: UIViewController {
    
    var viewModel: SignInViewModelProtocol
    weak var coordinator: RegistrationFlowCoordinatorProtocol?

    private var loginHeaderView: LoginHeaderView!
    private var emailTextField: InputTextField!
    private var passwordTextField: InputTextField!
    private var signInButton: LoginButtons!
    private var newUserButton: LoginButtons!
    private var forgotPasswordButton: LoginButtons!
    
    private var subscriptions = Set<AnyCancellable>()
    
    var completionHandler: (() -> ())?
    
    private lazy var loginStatusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "Invalid username or password. Try again"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .center
        label.isHidden = true
        label.textColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        return label
    }()
    
    init(
        viewModel: SignInViewModelProtocol,
        coordinator: RegistrationFlowCoordinatorProtocol)
    {
        self.coordinator = coordinator
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.passwordVerification.loadUsers()
    }
    
    private func bindViewModel() {
        viewModel.loginStatusLabelHidden
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] hidden in
                self.loginStatusLabel.isHidden = hidden
            }.store(in: &subscriptions)
        
        viewModel.signInButtonValidation
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] inUse in
                self.signInButton.isEnabled = inUse
                if !inUse {
                    self.signInButton.backgroundColor = .systemGray
                } else {
                    self.signInButton.backgroundColor = .systemBlue
                }
            }.store(in: &subscriptions)
        
        viewModel.userData
            .sink {[weak self] user in
                self?.coordinator?.endFlow(user: user)
            }.store(in: &subscriptions)
    }
    
    
    private func addTargets() {
        newUserButton.addTarget(self, action: #selector(didTapCreateNewUser), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(didTapForgotPassword), for: .touchUpInside)
    }
    
    
    private func createSubViews() {
        loginHeaderView = LoginHeaderView(title: "Sign In", subtitle: "Sign in to your account")
        
        emailTextField = InputTextField(fieldType: .email)
        emailTextField.delegate = self
        emailTextField.tag = 101
        passwordTextField = InputTextField(fieldType: .password)
        passwordTextField.delegate = self
        passwordTextField.tag = 102
        
        signInButton = LoginButtons(title: "Sign In", background: .systemGray, titleColor: .white, fontSize: .big)
        signInButton.addAction(
            UIAction(title: "didTapSignIn", handler: {[unowned self] _ in
                guard let emailString = self.emailTextField.text,
                      let passwordString = self.passwordTextField.text else { return }
                
                viewModel.didPressedSignInButton(emailString: emailString, passwordString: passwordString)
                
                self.loginStatusLabel.shake()
            }),
            for: .touchUpInside)
        
        signInButton.isEnabled = false
        newUserButton = LoginButtons(title: "New here? Create account.", background: .clear, titleColor: .systemBlue, fontSize: .medium)
        forgotPasswordButton = LoginButtons(title: "Forgot password?", background: .clear, titleColor: .systemBlue, fontSize: .small)
    }
    
    private func initializeHideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    

    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        initializeHideKeyboard()
        addTargets()
        
        [loginHeaderView, emailTextField, passwordTextField, signInButton, newUserButton, forgotPasswordButton, loginStatusLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            loginHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            loginHeaderView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            loginHeaderView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            loginHeaderView.heightAnchor.constraint(equalToConstant: 200),
            
            emailTextField.topAnchor.constraint(equalTo: loginHeaderView.bottomAnchor, constant: 20),
            emailTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emailTextField.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.85),
            emailTextField.heightAnchor.constraint(equalToConstant: 44),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.85),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),
            
            signInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            signInButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            signInButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.85),
            signInButton.heightAnchor.constraint(equalToConstant: 44),
            
            newUserButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 10),
            newUserButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            newUserButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.85),
            newUserButton.heightAnchor.constraint(equalToConstant: 44),
            
            forgotPasswordButton.topAnchor.constraint(equalTo: newUserButton.bottomAnchor, constant: 6),
            forgotPasswordButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            forgotPasswordButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.85),
            forgotPasswordButton.heightAnchor.constraint(equalToConstant: 30),
            
            loginStatusLabel.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 6),
            loginStatusLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            loginStatusLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.85),
            loginStatusLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    //MARK: - selectors
//    @objc private func didTapSignIn() {
//        guard let email = emailTextField.text,
//              let password = passwordTextField.text else { return }
//        viewModel.completionHandler = {[weak self] user in
//            self?.coordinator?.endFlow(user: user)
//        }
//        viewModel.didSignInPressed(email: email, password: password)
//        loginStatusLabel.shake()
//    }
    
    @objc private func didTapCreateNewUser() {
        coordinator?.showCreateNewUser()
    }
    
    @objc private func didTapForgotPassword() {
        coordinator?.showForgotPassword()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
}

extension SignInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = view.viewWithTag(textField.tag + 1) as? InputTextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        viewModel.validateTextFields(email: emailTextField.text, password: passwordTextField.text)
    }
    
}

