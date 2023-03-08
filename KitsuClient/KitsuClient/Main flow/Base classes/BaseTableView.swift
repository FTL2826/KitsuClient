//
//  BaseTableView.swift
//  KitsuClient
//
//  Created by Александр Харин on /73/23.
//

import UIKit

class BaseTableView: UIView {
    
    private var refreshText: String //"Fetching new anime titles"
    var refreshControl = UIRefreshControl()
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.separatorColor = .black
        table.isHidden = false
        
        refreshControl.tintColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        let attributedString = NSMutableAttributedString(string: refreshText)
        attributedString.addAttributes([.foregroundColor : #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)], range: (attributedString.string as NSString).range(of: refreshText) )
        refreshControl.attributedTitle = attributedString
        table.refreshControl = refreshControl
        
        return table
    }()

    init(refreshText: String) {
        self.refreshText = refreshText
        
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
    }
    
    func beginRefreshing() {
        refreshControl.beginRefreshing()
    }
    
    
    func setupUI() {
        addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
        ])
        
    }

}
