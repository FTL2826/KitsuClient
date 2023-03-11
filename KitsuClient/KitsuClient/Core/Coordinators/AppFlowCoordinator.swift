//
//  AppFlowCoordinator.swift
//  KitsuClient
//
//  Created by Александр Харин on /43/23.
//

import Foundation
import UIKit

class AppFlowCoordinator: AppFlowCoordinatorProtocol {
    
    
    var tabBarController: UITabBarController
    var navigationController: UINavigationController!
    
    var isAuth: Bool {
        get {
            return true
        }
    }
    
    
    var childCoordinators = [Coordinator]()
    
    let factory = MainFlowFactory()
    
    
    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
        self.navigationController = UINavigationController()
    }
    
    func start() {
        let tabBarAppearance = UITabBarAppearance()
        let tabBarItemAppearance = UITabBarItemAppearance()

        tabBarItemAppearance.normal.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
            .font: UIFont.systemFont(ofSize: 16)]
        tabBarItemAppearance.selected.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 16)]

        tabBarAppearance.stackedLayoutAppearance = tabBarItemAppearance

        tabBarController.tabBar.standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            tabBarController.tabBar.scrollEdgeAppearance = tabBarAppearance
        }
        
        tabBarController.tabBar.isHidden = true
        tabBarController.addChild(navigationController)
        
        if isAuth {
            showAnimeFeed(user: User(login: "test", email: "test", password: "test"))
        } else {
            showRegistration()
        }
    }
    
    private func showRegistration() {
        let registrationFlowCoordinator = CoordinatorsFactory().createRegistrationFlowCoordinator(navigationController: navigationController)
        registrationFlowCoordinator.start()
        childCoordinators.append(registrationFlowCoordinator)
        registrationFlowCoordinator.completionHandler = {[weak self] user in
            self?.navigationController = nil
            self?.showAnimeFeed(user: user)
        }
    }
    
    func showAnimeFeed(user: User) {
        tabBarController
            .setViewControllers([factory.createAnimeFeedModule(coordinator: self),
                                 factory.createMangaFeedModule(coordinator: self),
                                 factory.createProfileModule(coordinator: self, user: user)], animated: false)
        tabBarController.selectedIndex = 2
        tabBarController.tabBar.isHidden = false
        
        
    }
    
    func logout() {
        tabBarController.tabBar.isHidden = true
        
        navigationController = UINavigationController()
        tabBarController.viewControllers?.removeAll()
        tabBarController.addChild(navigationController)
        tabBarController.selectedIndex = 0
        
        showRegistration()
    }
    
    func showDetailInfoPage(titleInfo: TitleInfo) {
        let vc = factory.createBaseDetailModule(titleInfo: titleInfo)
//        vc.modalPresentationStyle = .fullScreen
        tabBarController.present(vc, animated: true)
    }
    
    
}
