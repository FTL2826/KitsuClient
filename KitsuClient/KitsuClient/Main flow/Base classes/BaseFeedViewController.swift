//
//  BaseFeedViewController.swift
//  KitsuClient
//
//  Created by Александр Харин on /83/23.
//

import Foundation
import UIKit

class BaseFeedViewController: UIViewController {
    
    var baseViewModel: BaseFeedViewModelProtocol?
    
    var segment: Segments = .trending
    
    private lazy var segmentedControl = UISegmentedControl(items: [Segments.trending.rawValue, Segments.alltime.rawValue])
    private var trendingTable: BaseTableView
    private var alltimeTable: BaseTableView
    
    
    init(
        viewModel: BaseFeedViewModelProtocol,
        trendingTableRefresherText: String,
        alltimeTableRefresherText: String
    ) {
        self.baseViewModel = viewModel
        trendingTable = BaseTableView(refreshText: trendingTableRefresherText)
        alltimeTable = BaseTableView(refreshText: alltimeTableRefresherText)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        setupUI()
        addTargets()
    }
    
    deinit {
        print("Manga view controller was destroyed")
    }
    
    func bindViewModel() {
        guard let baseViewModel = baseViewModel else { return }
       
        baseViewModel.isTrendingLoading.bind { [weak self] loading in
            DispatchQueue.main.async {
                if loading {
                    self?.trendingTable.beginRefreshing()
                } else {
                    self?.trendingTable.endRefreshing()
                }
            }
        }
        baseViewModel.isAlltimeLoading.bind { [weak self] loading in
            DispatchQueue.main.async {
                if loading {
                    self?.alltimeTable.beginRefreshing()
                } else {
                    self?.alltimeTable.endRefreshing()
                }
            }
        }
        
    }
    
    // thread safe
    func reloadTrendingTable() {
        trendingTable.reloadData()
    }
    func reloadAlltimeTable() {
        alltimeTable.reloadData()
    }
    
    private func addTargets() {
        segmentedControl.addTarget(self, action: #selector(didChangeSegment), for: .valueChanged)
        
        trendingTable.refreshControl.addTarget(self, action: #selector(pullToFetchTrending), for: .valueChanged)
        alltimeTable.refreshControl.addTarget(self, action: #selector(pullToFetchAlltime), for: .valueChanged)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        segmentedControl.selectedSegmentIndex = 0
        trendingTable.isHidden = false
        alltimeTable.isHidden = true
        
        trendingTable.tableView.dataSource = self
        trendingTable.tableView.delegate = self
        
        alltimeTable.tableView.dataSource = self
        alltimeTable.tableView.delegate = self
        
        view.addSubview(segmentedControl)
        view.addSubview(trendingTable)
        view.addSubview(alltimeTable)
        
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        trendingTable.translatesAutoresizingMaskIntoConstraints = false
        alltimeTable.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            trendingTable.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            trendingTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            trendingTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            trendingTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            alltimeTable.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            alltimeTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            alltimeTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            alltimeTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            
        ])
        
    }
    
    
    //MARK: - selectors
    @objc private func didChangeSegment() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            segment = .trending
            trendingTable.isHidden = false
            alltimeTable.isHidden = true
            reloadTrendingTable()
        case 1:
            segment = .alltime
            trendingTable.isHidden = true
            alltimeTable.isHidden = false
            reloadAlltimeTable()
            
        default:
            break
        }
    }
    
    @objc private func pullToFetchTrending() {
        baseViewModel?.fetchTrendingData()
    }
    
    @objc private func pullToFetchAlltime() {
        baseViewModel?.fetchAlltimeData()
    }

}

extension BaseFeedViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        baseViewModel?.numbersOfSections(segment: segment) ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        baseViewModel?.numbersOfRowsInSection(section: section, segment: segment) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .systemBackground
        
        
        cell.textLabel?.text = String(indexPath.row)
        
        return cell
    }
    
}
