//
//  ForgotViewController.swift
//  KitsuClient
//
//  Created by Александр Харин on /23/23.
//

import UIKit

class ForgotViewController: UIViewController {
    
    var viewModel: ForgotViewModelProtocol?
    
    private var views: [UIView] = []
    private var headerView: LoginHeaderView!
    private var loginTextField: InputTextField!
    private var resetPasswordButton: LoginButtons!
    
    private lazy var resetPasswordStatusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "resetPasswordStatus"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .center
        label.isHidden = true
        label.numberOfLines = 0
        return label
    }()
    
    init(viewModel: ForgotViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        
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
        
        setupUI()
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        viewModel.forgotPasswordButtonValidation.bind {[weak self] inUse in
            DispatchQueue.main.async {
                self?.resetPasswordButton.isEnabled = inUse
                if !inUse {
                    self?.resetPasswordButton.backgroundColor = .systemGray
                } else {
                    self?.resetPasswordButton.backgroundColor = .systemBlue
                }
            }
        }
        
        viewModel.loginStatus.bind {[weak self] statusText in
            DispatchQueue.main.async {
                self?.resetPasswordStatusLabel.text = statusText
            }
        }
        
        viewModel.textColor.bind {[weak self] color in
            DispatchQueue.main.async {
                switch color {
                case .red:
                    self?.resetPasswordStatusLabel.textColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
                case .green:
                    self?.resetPasswordStatusLabel.textColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 0.927573804)
                }
            }
        }
        
    }
    
    private func createSubViews() {
        headerView = LoginHeaderView(title: "Forgot password?", subtitle: "Reset your password")
        
        loginTextField = InputTextField(fieldType: .userName)
        loginTextField.tag = 101
        loginTextField.delegate = self
        
        resetPasswordButton = LoginButtons(title: "Reset password", background: .systemGray, titleColor: .white, fontSize: .big)
        
        views = [headerView,
                 loginTextField,
                 resetPasswordButton,
                 resetPasswordStatusLabel,
        ]
    }
    
    private func initializeHideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    private func addTargets() {
        resetPasswordButton.addTarget(self, action: #selector(didPressedResetPasswordButton), for: .touchUpInside)
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
            loginTextField.heightAnchor.constraint(equalToConstant: 44),
            
            resetPasswordButton.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 30),
            resetPasswordButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            resetPasswordButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.85),
            resetPasswordButton.heightAnchor.constraint(equalToConstant: 44),
            
            resetPasswordStatusLabel.topAnchor.constraint(equalTo: resetPasswordButton.bottomAnchor, constant: 6),
            resetPasswordStatusLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            resetPasswordStatusLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.85),
            
            
        ])
        
    }
    
    //MARK: - selectors
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func didPressedResetPasswordButton() {
        viewModel?.didPressedResetPasswordButton(login: loginTextField.text)
        resetPasswordStatusLabel.isHidden = false
    }

}


extension ForgotViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = view.viewWithTag(textField.tag + 1) as? InputTextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        viewModel?.validateTextFields(login: loginTextField.text)
    }
    
}
