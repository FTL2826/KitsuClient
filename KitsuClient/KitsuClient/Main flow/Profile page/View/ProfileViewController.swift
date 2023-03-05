//
//  ProfileViewController.swift
//  KitsuClient
//
//  Created by Александр Харин on /53/23.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var user: User?
    var views = [UIView]()
    
    weak var coordinator: AppFlowCoordinatorProtocol?
    
    private lazy var profilePic: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "face.dashed.fill")
        return iv
    }()
    private lazy var nicknameLabel: UILabel = {
        let l = UILabel()
        l.text = "Error"
        l.numberOfLines = 1
        l.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        l.textAlignment = .center
        l.textColor = .label
        return l
    }()
    private lazy var emailLabel: UILabel = {
        let l = UILabel()
        l.text = "Error"
        l.numberOfLines = 1
        l.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        l.textAlignment = .center
        l.textColor = .secondaryLabel
        return l
    }()
    private lazy var logoutButton: UIButton = {
        let b = UIButton()
        b.setBackgroundImage(UIImage(systemName: "door.left.hand.open"), for: .normal)
        b.tintColor = .systemRed
        return b
    }()
    
    init(
        coordinator: AppFlowCoordinatorProtocol
    ) {
        super.init(nibName: nil, bundle: nil)
        
        self.coordinator = coordinator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        createSubviews()
        
        super.loadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    deinit {
        print("Profile view controller was destroyed")
    }
    
    private func createSubviews() {
        nicknameLabel.text = user?.login
        emailLabel.text = user?.email
        
        
        views = [profilePic, nicknameLabel,
                 emailLabel,
                 logoutButton]
    }
    
    private func addTargets() {
        logoutButton.addTarget(self, action: #selector(didPressedLogoutButton), for: .touchUpInside)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        addTargets()
        
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            profilePic.heightAnchor.constraint(equalToConstant: 100),
            profilePic.widthAnchor.constraint(equalToConstant: 100),
            profilePic.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            profilePic.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            nicknameLabel.topAnchor.constraint(equalTo: profilePic.topAnchor, constant: 16),
            nicknameLabel.leadingAnchor.constraint(equalTo: profilePic.trailingAnchor, constant: 16),
            
            emailLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 6),
            emailLabel.leadingAnchor.constraint(equalTo: nicknameLabel.leadingAnchor),
            
            logoutButton.heightAnchor.constraint(equalToConstant: 55),
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.centerYAnchor.constraint(equalTo: profilePic.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
        
    }

    
    
    //MARK: - selectors
    @objc private func didPressedLogoutButton() {
        print("Logout")
        coordinator?.logout()
    }
    
    
    
}
