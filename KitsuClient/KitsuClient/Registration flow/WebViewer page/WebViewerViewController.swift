//
//  WebViewerViewController.swift
//  KitsuClient
//
//  Created by Александр Харин on /33/23.
//

import UIKit
import WebKit

class WebViewerViewController: UIViewController {
    
    private var webView = WKWebView()
    private var url: URL
    
    init(with url: URL) {
        self.url = url
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupUI()
    }
    
    deinit {
        print("DEINIT:", "WebViewer was destroyed")
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        webView = WKWebView(frame: view.bounds, configuration: WKWebViewConfiguration())
        webView.center = view.center
        
        view.addSubview(webView)
        
        DispatchQueue.main.async {[weak self] in
            if let url = self?.url {
                self?.webView.load(URLRequest(url: url))
            }
        }
        
    }

}
