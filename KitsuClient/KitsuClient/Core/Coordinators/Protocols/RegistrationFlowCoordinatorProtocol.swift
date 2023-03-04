//
//  Coordinator.swift
//  KitsuClient
//
//  Created by Александр Харин on /23/23.
//

import Foundation
import UIKit.UINavigationController

protocol RegistrationFlowCoordinatorProtocol: Coordinator {
    
    var navigationController: UINavigationController { get set }
    var completionHandler: ((User) -> ())? { get set }
    
    
    func start()
    
    func showSignIn()
    func showCreateNewUser()
    func showForgotPassword()
    func showWebViewer(url: URL)
    
    func endFlow(user: User)
    
}
