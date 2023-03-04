//
//  AnimeFeedViewController.swift
//  KitsuClient
//
//  Created by Александр Харин on /43/23.
//

import UIKit

class AnimeFeedViewController: UIViewController {
    
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .cyan
        
        print("User: ", user)
    }

}
