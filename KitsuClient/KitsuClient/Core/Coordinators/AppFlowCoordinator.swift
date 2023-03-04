//
//  AppFlowCoordinator.swift
//  KitsuClient
//
//  Created by Александр Харин on /43/23.
//

import Foundation
import UIKit

class AppFlowCoordinator: AppFlowCoordinatorProtocol {
    
    var navigationController = UINavigationController()
    var childCoordinators = [Coordinator]()
    
    let factory = MainFlowFactory()
    
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        // if not Auth
        showRegistration()
    }
    
    private func showRegistration() {
        let registrationFlowCoordinator = CoordinatorsFactory().createRegistrationFlowCoordinator(navigationController: navigationController)
        registrationFlowCoordinator.start()
        childCoordinators.append(registrationFlowCoordinator)
        registrationFlowCoordinator.completionHandler = {[weak self] user in
            self?.showAnimeFeed(user: user)
        }
    }
    
    func showAnimeFeed(user: User) {
        let vc = factory.createAnimeFeedModule()
        vc.user = user
        navigationController.pushViewController(vc, animated: true)
    }
    
    
}
