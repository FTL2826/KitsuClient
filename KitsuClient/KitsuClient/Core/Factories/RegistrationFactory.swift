//
//  RegistrationFactory.swift
//  KitsuClient
//
//  Created by Александр Харин on /23/23.
//

class RegistrationFactory {
    
    func createSignInModule(coordinator: RegistrationFlowCoordinatorProtocol) -> SignInViewController {
        let vc = SignInViewController(viewModel: SignInViewModel(), coordinator: coordinator)
        
        return vc
    }
    
    func createSignUpModule(coordinator: RegistrationFlowCoordinatorProtocol) -> SignUpViewController {
        let vc = SignUpViewController(viewModel: SignUpViewModel(), coordinator: coordinator)
        
        return vc
    }
    
    
}
