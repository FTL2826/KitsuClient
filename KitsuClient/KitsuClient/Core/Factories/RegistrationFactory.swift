//
//  RegistrationFactory.swift
//  KitsuClient
//
//  Created by Александр Харин on /23/23.
//

import Foundation

class RegistrationFactory {
    
    let servicesFactory = ServicesFactory()
    
    func createSignInModule(coordinator: RegistrationFlowCoordinatorProtocol) -> SignInViewController {
        let vc = SignInViewController(
            viewModel: SignInViewModel(
                passwordVerification: servicesFactory.createPasswordVerification()),
            coordinator: coordinator)
        
        return vc
    }
    
    func createSignUpModule(coordinator: RegistrationFlowCoordinatorProtocol) -> SignUpViewController {
        let vc = SignUpViewController(
            viewModel: SignUpViewModel(
                passwordVerification: servicesFactory.createPasswordVerification()),
            coordinator: coordinator)
        
        return vc
    }
    
    func createForgotPasswordModule(coordinator: RegistrationFlowCoordinatorProtocol) -> ForgotViewController {
        let vc = ForgotViewController(
            viewModel: ForgotViewModel(
                passwordVerification: servicesFactory.createPasswordVerification()))
        
        return vc
    }
    
    func createWebViewerModule(url: URL) -> WebViewerViewController {
        let vc = WebViewerViewController(with: url)
        
        return vc
    }
    
    
}
