//
//  AppFlowCoordinatorProtocol.swift
//  KitsuClient
//
//  Created by Александр Харин on /43/23.
//

import Foundation
import UIKit.UITabBarController

protocol AppFlowCoordinatorProtocol: AnyObject {
    
    var tabBarController: UITabBarController { get }
    
    func start()
    func showAnimeFeed(user: User)
    func logout()
    
}
