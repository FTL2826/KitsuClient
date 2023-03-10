//
//  SignInViewController.swift
//  KitsuClient
//
//  Created by Александр Харин on /282/23.
//

import UIKit

class SignInViewController: UIViewController {
    
    var viewModel: SignInViewModelProtocol?
    weak var coordinator: RegistrationFlowCoordinatorProtocol?
    
    private var views: [UIView] = []
    private var loginHeaderView: LoginHeaderView!
    private var emailTextField: InputTextField!
    private var passwordTextField: InputTextField!
    private var signInButton: LoginButtons!
    private var newUserButton: LoginButtons!
    private var forgotPasswordButton: LoginButtons!
    
    var completionHandler: (() -> ())?
    
    private lazy var loginStatusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "loginStatusLabel"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    init(
        viewModel: SignInViewModelProtocol,
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel?.passwordVerification?.loadUsers()
    }
    
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        viewModel.loginStatusLabelHidden.bind {[weak self] hidden in
            DispatchQueue.main.async {
                self?.loginStatusLabel.isHidden = hidden
            }
        }
        
        viewModel.loginStatus.bind {[weak self] statusText in
            DispatchQueue.main.async {
                self?.loginStatusLabel.text = statusText
            }
        }
        
        viewModel.textColor.bind {[weak self] color in
            DispatchQueue.main.async {
                switch color {
                case .red:
                    self?.loginStatusLabel.textColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
                case .green:
                    self?.loginStatusLabel.textColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 0.927573804)
                }
            }
        }
        
        viewModel.signInButtonValidation.bind {[weak self] inUse in
            DispatchQueue.main.async {
                self?.signInButton.isEnabled = inUse
                if !inUse {
                    self?.signInButton.backgroundColor = .systemGray
                } else {
                    self?.signInButton.backgroundColor = .systemBlue
                }
            }
        }
    }
    
    
    private func addTargets() {
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
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
        signInButton.isEnabled = false
        newUserButton = LoginButtons(title: "New here? Create account.", background: .clear, titleColor: .systemBlue, fontSize: .medium)
        forgotPasswordButton = LoginButtons(title: "Forgot password?", background: .clear, titleColor: .systemBlue, fontSize: .small)
        
        views = [loginHeaderView,
                 emailTextField,
                 passwordTextField,
                 signInButton,
                 newUserButton,
                 forgotPasswordButton,
                 loginStatusLabel]
    }
    
    private func initializeHideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    

    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        initializeHideKeyboard()
        addTargets()
        
        views.forEach {
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
    @objc private func didTapSignIn() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else { return }
        viewModel?.completionHandler = {[weak self] user in
            self?.coordinator?.endFlow(user: user)
        }
        viewModel?.didSignInPressed(email: email, password: password)
        loginStatusLabel.shake()
    }
    
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
        viewModel?.validateTextFields(email: emailTextField.text, password: passwordTextField.text)
    }
    
}

