//
//  Coordinator.swift
//  KitsuClient
//
//  Created by Александр Харин on /23/23.
//

import Foundation
import UIKit.UINavigationController

protocol RegistrationFlowCoordinatorProtocol: AnyObject {
    
    var navigationController: UINavigationController { get set }
    
    
    func start()
    
    func showSignIn()
    func showCreateNewUser()
    func showForgotPassword()
    func showWebViewer(url: URL)
    
}
