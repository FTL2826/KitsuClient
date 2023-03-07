//
//  AnimeFeedViewController.swift
//  KitsuClient
//
//  Created by Александр Харин on /43/23.
//

import UIKit

class AnimeFeedViewController: UIViewController {
    
    var viewModel: AnimeFeedViewModelProtocol?
    weak var coordinator: AppFlowCoordinatorProtocol?
    
    var views: [UIView] = []
    
    private lazy var refreshControl = UIRefreshControl()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorColor = .black
        tableView.isHidden = false
        tableView.refreshControl = refreshControl
        tableView.refreshControl?.tintColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        
        let attributedString = NSMutableAttributedString(string: "Fetching new anime titles")
        attributedString.addAttributes([.foregroundColor : #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)], range: (attributedString.string as NSString).range(of: "Fetching new anime titles") )
        tableView.refreshControl?.attributedTitle = attributedString
        
        return tableView
    }()
    
    
    init(
        viewModel: AnimeFeedViewModelProtocol,
        coordinator: AppFlowCoordinatorProtocol
    ) {
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel = viewModel
        self.coordinator = coordinator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        views = [tableView]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setupUI()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    deinit {
        print("AnimeFeedViewController was destroyed")
    }
    
    private func bindViewModel() {
        viewModel?.isLoading.bind(listener: { [weak self] loading in
            DispatchQueue.main.async {
                if !loading {
                    self?.refreshControl.endRefreshing()
                }
            }
        })
        
        viewModel?.dataSource.bind(listener: { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        })
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        refreshControl.addTarget(self, action: #selector(pullToFetch), for: .valueChanged)
        
        views.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    
    //MARK: - selectors
    @objc private func pullToFetch() {
        viewModel?.fetchData()
    }
    
}

extension AnimeFeedViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel?.numbersOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.rowsInSection(section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .systemBackground
        
        
        cell.textLabel?.text = viewModel?.getAnimeTitle(indexPath)
        
        return cell
    }
}
