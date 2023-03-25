//
//  ForgotViewController.swift
//  KitsuClient
//
//  Created by Александр Харин on /23/23.
//

import UIKit
import Combine

class ForgotViewController: UIViewController {
    
    var viewModel: ForgotViewModelProtocol
    
    private var headerView: LoginHeaderView!
    private var emailTextField: InputTextField!
    private var resetPasswordButton: LoginButtons!
    
    var subscriptions = Set<AnyCancellable>()
    
    private lazy var resetPasswordStatusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "resetPasswordStatus"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .center
        label.isHidden = true
        label.numberOfLines = 0
        label.textColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        return label
    }()
    
    init(viewModel: ForgotViewModelProtocol) {
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
        
        setupUI()
        bindViewModel()
    }
    
    private func bindViewModel() {
        
        emailTextField.textPublisher
            .sink {[unowned self] text in
                self.viewModel.emailTextFieldValue.send(text)
            }.store(in: &subscriptions)
        
        viewModel.resetPasswordButtonEnable
            .receive(on: DispatchQueue.main)
            .sink {[unowned self] enable in
                self.resetPasswordButton.isEnabled = enable
                if enable {
                    self.resetPasswordButton.backgroundColor = .systemBlue
                } else {
                    self.resetPasswordButton.backgroundColor = .systemGray
                }
            }.store(in: &subscriptions)
        
        Publishers.CombineLatest(viewModel.resetPasswordStatusLabelValue, viewModel.resetPasswordStatusLabelHidden)
            .receive(on: DispatchQueue.main)
            .sink {[unowned self] (labelText, hidden) in
                self.resetPasswordStatusLabel.isHidden = hidden
                self.resetPasswordStatusLabel.text = labelText
                if !hidden {
                    self.resetPasswordStatusLabel.shake()
                }
            }.store(in: &subscriptions)
        
        viewModel.makeStatusLabelGreen
            .receive(on: DispatchQueue.main)
            .sink { green in
                if green {
                    self.resetPasswordStatusLabel.textColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 0.927573804)
                } else {
                    self.resetPasswordStatusLabel.textColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
                }
            }.store(in: &subscriptions)
        
    }
    
    private func createSubViews() {
        headerView = LoginHeaderView(title: "Forgot password?", subtitle: "Reset your password")
        
        emailTextField = InputTextField(fieldType: .email)
        emailTextField.tag = 101
        emailTextField.delegate = self
        
        resetPasswordButton = LoginButtons(title: "Reset password", background: .systemGray, titleColor: .white, fontSize: .big)
        resetPasswordButton.addAction(
            UIAction(title: "didPressedResetPasswordButton", handler: {[unowned self] _ in
                self.viewModel.didPressedResetPasswordButton()
                self.resetPasswordStatusLabel.isHidden = false
            }),
            for: .touchUpInside)
    }
    
    private func initializeHideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        initializeHideKeyboard()
        
        [headerView, emailTextField, resetPasswordButton, resetPasswordStatusLabel,].forEach{
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 200),
            
            emailTextField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            emailTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emailTextField.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.85),
            emailTextField.heightAnchor.constraint(equalToConstant: 44),
            
            resetPasswordButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30),
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
    
}
