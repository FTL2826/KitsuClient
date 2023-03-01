//
//  LoginHeaderView.swift
//  KitsuClient
//
//  Created by Александр Харин on /13/23.
//

import Foundation
import UIKit

class LoginHeaderView: UIView {
    
    var views = [UIView]()
    
    private lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Error"
        l.numberOfLines = 1
        l.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        l.textAlignment = .center
        l.textColor = .label
        return l
    }()
    private lazy var subtitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Error"
        l.numberOfLines = 1
        l.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        l.textAlignment = .center
        l.textColor = .secondaryLabel
        return l
    }()
    
    private lazy var logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "loginLogo")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var vStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .fillProportionally
        stack.alignment = .center
        return stack
    }()
    
    init(title: String, subtitle: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        subtitleLabel.text = subtitle
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        
        views = [logoImageView, titleLabel, subtitleLabel]
        addSubview(vStack)
        
        views.forEach {
            vStack.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            vStack.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            vStack.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            vStack.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            vStack.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
            
        ])
    }
    
    
}
