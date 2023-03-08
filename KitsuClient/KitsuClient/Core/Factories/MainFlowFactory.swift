//
//  MainFlowFactory.swift
//  KitsuClient
//
//  Created by Александр Харин on /53/23.
//

import Foundation
import UIKit

class MainFlowFactory {
    
    func createAnimeFeedModule(coordinator: AppFlowCoordinatorProtocol) -> AnimeFeedViewController {
        let viewModel = AnimeFeedViewModel(
            apiClient: API.Client.shared)
        
        let vc = AnimeFeedViewController(
            viewModel: viewModel)
        vc.tabBarItem = UITabBarItem(
            title: "Anime",
            image: UIImage(systemName: "desktopcomputer"),
            selectedImage: UIImage(systemName: "play.desktopcomputer"))
        return vc
    }
    
    func createMangaFeedModule() -> MangaFeedViewController {
        let viewModel = MangaFeedViewModel(
            apiClient: API.Client.shared)
        
        let vc = MangaFeedViewController(viewModel: viewModel)
        vc.tabBarItem = UITabBarItem(
            title: "Manga",
            image: UIImage(systemName: "123.rectangle"),
            selectedImage: UIImage(systemName: "123.rectangle.fill"))
        return vc
    }
    
    func createProfileModule(coordinator: AppFlowCoordinatorProtocol, user: User) -> ProfileViewController {
        let vc = ProfileViewController(coordinator: coordinator)
        vc.user = user
        vc.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person.crop.circle"),
            selectedImage: UIImage(systemName: "person.crop.circle.fill"))
        return vc
    }
}
