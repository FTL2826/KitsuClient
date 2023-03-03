//
//  CoordinatorsFactory.swift
//  KitsuClient
//
//  Created by Александр Харин on /23/23.
//

import Foundation
import UIKit.UINavigationController

class CoordinatorsFactory {
    
    func createRegistrationFlowCoordinator(navigationController: UINavigationController) -> RegistrationFlowCoordinator {
        RegistrationFlowCoordinator(navigationController: navigationController)
    }
    
    
}
