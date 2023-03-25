//
//  ProfileViewController.swift
//  KitsuClient
//
//  Created by Александр Харин on /53/23.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var user: User
    weak var coordinator: AppFlowCoordinatorProtocol?
    
    let identifier = "Identifier"
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.numberOfLines = 0
        label.text = "Profile"
        return label
    }()
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
    private lazy var table: UITableView = {
        let table = UITableView()
        table.rowHeight = 44
        return table
    }()
    
    init(
        coordinator: AppFlowCoordinatorProtocol,
        user: User
    ) {
        self.coordinator = coordinator
        self.user = user
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        configureLabels()
        
        super.loadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        table.delegate = self
        table.dataSource = self
    }
    
    deinit {
        print("Profile view controller was destroyed")
    }
    
    private func configureLabels() {
        nicknameLabel.text = user.login.string
        emailLabel.text = user.credentials.email.string
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        [titleLabel, profilePic, nicknameLabel, emailLabel, table].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 6),
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            profilePic.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            profilePic.heightAnchor.constraint(equalToConstant: 100),
            profilePic.widthAnchor.constraint(equalToConstant: 100),
            profilePic.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            
            nicknameLabel.topAnchor.constraint(equalTo: profilePic.bottomAnchor, constant: 6),
            nicknameLabel.centerXAnchor.constraint(equalTo: profilePic.centerXAnchor),
            
            emailLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 6),
            emailLabel.centerXAnchor.constraint(equalTo: nicknameLabel.centerXAnchor),
            
            table.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 6),
            table.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            table.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5),
            table.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        ])
        
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
        cell.selectionStyle = .none
        cell.backgroundColor = #colorLiteral(red: 0.6642269492, green: 0.6642268896, blue: 0.6642268896, alpha: 0.5)
        cell.textLabel?.text = "Log out"
        cell.textLabel?.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            coordinator?.logout()
        }
    }
    
    
}
