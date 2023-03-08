//
//  Coordinator.swift
//  KitsuClient
//
//  Created by Александр Харин on /43/23.
//

import Foundation
import UIKit.UINavigationController

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    
    func start()
}
