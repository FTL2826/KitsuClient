//
//  AppCoordinator.swift
//  KitsuClient
//
//  Created by Александр Харин on /23/23.
//

import Foundation
import UIKit.UINavigationController

class RegistrationFlowCoordinator: RegistrationFlowCoordinatorProtocol {
    
    private let moduleFactory = RegistrationFactory()
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showSignIn()
    }
    
    func showSignIn() {
        let vc = moduleFactory.createSignInModule(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showCreateNewUser() {
        let vc = moduleFactory.createSignUpModule(coordinator: self)
        vc.modalPresentationStyle = .fullScreen
        navigationController.viewControllers.last?.present(vc, animated: true)
    }
    
    func showForgotPassword() {
        let vc = ForgotViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    
}
