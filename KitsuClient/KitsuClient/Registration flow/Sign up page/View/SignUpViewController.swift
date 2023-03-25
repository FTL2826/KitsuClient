//
//  SignUpViewController.swift
//  KitsuClient
//
//  Created by Александр Харин on /23/23.
//

import UIKit
import Combine

fileprivate enum TextViewURLs: String {
    case terms = "https://policies.google.com/terms?hl=en-US"
    case privacy = "https://policies.google.com/privacy?hl=en-US"
}

class SignUpViewController: UIViewController {
    
    var viewModel: SignUpViewModelProtocol
    weak var coordinator: RegistrationFlowCoordinatorProtocol?
    
    private var headerView: LoginHeaderView!
    private var loginTextField: InputTextField!
    private var emailTextField: InputTextField!
    private var passwordTextField: InputTextField!
    private var signUpButton: LoginButtons!
    private var signInButton: LoginButtons!
    
    private var loginText = PassthroughSubject<String, Never>()
    
    private var subscriptions = Set<AnyCancellable>()
    
    private lazy var termsTextView: UITextView = {
        let attributedString = NSMutableAttributedString(string: "By creating an account you agree to our Terms & Conditions and you aknowledge that you have read our Privacy Policy.")
        
        attributedString.addAttribute(.link, value: TextViewURLs.terms.rawValue, range: (attributedString.string as NSString).range(of: "Terms & Conditions"))
        attributedString.addAttribute(.link, value: TextViewURLs.privacy.rawValue, range: (attributedString.string as NSString).range(of: "Privacy Policy"))
        
        let tv = UITextView()
        tv.linkTextAttributes = [.foregroundColor: UIColor.systemBlue]
        tv.attributedText = attributedString
        tv.backgroundColor = .clear
        tv.textColor = .label
        tv.isSelectable = true
        tv.isEditable = false
        tv.delaysContentTouches = false
        tv.isScrollEnabled = false
        return tv
    }()
    
    private lazy var uniqEmailStatusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "That email was already used for another account"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .center
        label.isHidden = true
        label.numberOfLines = 0
        label.textColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        return label
    }()
    
    
    init(viewModel: SignUpViewModelProtocol,
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
    
    private func bindViewModel() {
        
        loginTextField.textPublisher
            .sink {[unowned self] text in
                self.viewModel.loginTextFieldValue.send(text)
            }.store(in: &subscriptions)
        
        emailTextField.textPublisher
            .sink {[unowned self] text in
                self.viewModel.emailTextFieldValue.send(text)
            }.store(in: &subscriptions)
        
        passwordTextField.textPublisher
            .sink {[unowned self] text in
                self.viewModel.passwordTextFieldValue.send(text)
            }.store(in: &subscriptions)
        
        viewModel.uniqEmailStatus
            .zip(viewModel.uniqEmailStatusHidden)
            .receive(on: DispatchQueue.main)
            .sink {[unowned self] (labelText, hidden) in
                self.uniqEmailStatusLabel.text = labelText
                self.uniqEmailStatusLabel.isHidden = hidden
                self.uniqEmailStatusLabel.shake()
            }.store(in: &subscriptions)
        
        viewModel.signUpButtonEnable
            .receive(on: DispatchQueue.main)
            .sink {[unowned self] hidden in
                self.signUpButton.isEnabled = hidden
                if hidden {
                    self.signUpButton.backgroundColor = .systemBlue
                } else {
                    self.signUpButton.backgroundColor = .systemGray
                }
            }.store(in: &subscriptions)
        
        viewModel.goToSignInScreen
            .receive(on: DispatchQueue.main)
            .sink {[unowned self] goTo in
                self.coordinator?.showSignIn()
            }.store(in: &subscriptions)
        
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
        
        signUpButton = LoginButtons(title: "Sign Up", background: .systemGray, titleColor: .white, fontSize: .big)
        signUpButton.addAction(
            UIAction(title: "didPressedSignUpButton", handler: {[unowned self] _ in
                self.viewModel.didPressedSignUpButton()
                self.coordinator?.showSignIn()
            }),
            for: .touchUpInside)
        
        signInButton = LoginButtons(title: "Already have an account? Sign in.", background: .clear, titleColor: .systemBlue, fontSize: .medium)
        signInButton.addAction(
            UIAction(title: "didPressedSignInButton", handler: {[unowned self] _ in
                self.viewModel.didPressedSignInButton()
            }),
            for: .touchUpInside)
        
        termsTextView.delegate = self
    }
    
    private func initializeHideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        initializeHideKeyboard()
        
        
        [headerView, loginTextField, emailTextField, passwordTextField, signUpButton, signInButton, termsTextView, uniqEmailStatusLabel, ]
            .forEach{
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
            loginTextField.heightAnchor.constraint(equalToConstant: 44),
            
            emailTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 10),
            emailTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emailTextField.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.85),
            emailTextField.heightAnchor.constraint(equalToConstant: 44),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
            passwordTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.85),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),
            
            signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            signUpButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            signUpButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.85),
            signUpButton.heightAnchor.constraint(equalToConstant: 44),
            
            signInButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 6),
            signInButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            signInButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.85),
            signInButton.heightAnchor.constraint(equalToConstant: 30),
            
            termsTextView.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 6),
            termsTextView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            termsTextView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            
            uniqEmailStatusLabel.topAnchor.constraint(equalTo: termsTextView.bottomAnchor, constant: 6),
            uniqEmailStatusLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            uniqEmailStatusLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.85),
            
        ])
        
    }
    
    //MARK: - selectors
    @objc private func dismissKeyboard() {
        view.endEditing(true)
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


extension SignUpViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        coordinator?.showWebViewer(url: URL)
        
        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        textView.selectedTextRange = nil
    }
    
}
