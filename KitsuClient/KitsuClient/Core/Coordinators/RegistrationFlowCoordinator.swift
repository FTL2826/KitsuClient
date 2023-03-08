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
    var completionHandler: ((User) -> ())?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showSignIn()
    }
    
    func showSignIn() {
        
        if let lastVC = navigationController.viewControllers.last?.presentedViewController, lastVC.isKind(of: SignUpViewController.self) {
            navigationController.viewControllers.last?.dismiss(animated: true)
        } else {
            let vc = moduleFactory.createSignInModule(coordinator: self)
            navigationController.pushViewController(vc, animated: true)
        }
        
    }
    
    func showCreateNewUser() {
        let vc = moduleFactory.createSignUpModule(coordinator: self)
        vc.modalPresentationStyle = .fullScreen
        navigationController.viewControllers.last?.present(vc, animated: true)
    }
    
    func showForgotPassword() {
        let vc = moduleFactory.createForgotPasswordModule(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showWebViewer(url: URL) {
        if let lastVC = navigationController.viewControllers.last?.presentedViewController, lastVC.isKind(of: SignUpViewController.self) {
            let vc = moduleFactory.createWebViewerModule(url: url)
            lastVC.present(vc, animated: true)
        }
    }
    
    func endFlow(user: User) {
        completionHandler?(user)
    }
    
    
}
