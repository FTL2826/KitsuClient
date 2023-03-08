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
    private lazy var segmentedControl = UISegmentedControl(items: [Segments.trending.rawValue, Segments.alltime.rawValue])
    
    
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
        views = [segmentedControl,
                 tableView]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setupUI()
        
        setControls()
        
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
                } else {
                    self?.refreshControl.beginRefreshing()
                    self?.refreshControl.isHidden = false
                }
            }
        })
        
        viewModel?.dataSource.bind(listener: { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        })
    }
    
    private func setControls() {
        refreshControl.addTarget(self, action: #selector(pullToFetch), for: .valueChanged)
        
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        views.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        segmentedControl.selectedSegmentIndex = 1
        tableView.reloadData()
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            segmentedControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    
    //MARK: - selectors
    @objc private func pullToFetch() {
        viewModel?.fetchData()
    }
    
    @objc private func segmentChanged() {
        if segmentedControl.selectedSegmentIndex == 0 {
            viewModel?.segmentChanged(.trending)
        } else if segmentedControl.selectedSegmentIndex == 1 {
            viewModel?.segmentChanged(.alltime)
        }
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
