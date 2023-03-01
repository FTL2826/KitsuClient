//
//  LoginViewController.swift
//  KitsuClient
//
//  Created by Александр Харин on /282/23.
//

import UIKit

class LoginViewController: UIViewController {
    
    let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .cyan
        apiCall()
    }
    
    private func apiCall() {
        apiClient
            .get(.anime(offset: "0")) { (result: Result<API.Types.Response.AnimeSearch, API.Types.Error>) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let success):
                        print("Result from API:", success)
                    case .failure(let failure):
                        print("error:", failure.localizedDescription)
                    }
                }
            }
    }


}

