//
//  CoordinatorsFactory.swift
//  KitsuClient
//
//  Created by Александр Харин on /23/23.
//

import Foundation
import UIKit.UINavigationController
import UIKit.UITabBarController

class CoordinatorsFactory {
    
    func createRegistrationFlowCoordinator(navigationController: UINavigationController) -> RegistrationFlowCoordinator {
        RegistrationFlowCoordinator(navigationController: navigationController)
    }
    
    func createAppFlowCoordinator(tabBarController: UITabBarController) -> AppFlowCoordinator {
        AppFlowCoordinator(tabBarController: tabBarController)
    }
    
    
}
