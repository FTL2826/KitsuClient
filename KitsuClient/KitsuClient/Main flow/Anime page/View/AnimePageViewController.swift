//
//  AnimePageViewController.swift
//  KitsuClient
//
//  Created by Александр Харин on /313/23.
//

import Foundation
import UIKit
import Combine



class AnimePageViewController: UIViewController {
    
    weak var coordinator: AppFlowCoordinatorProtocol?
    var viewModel: AnimePageViewModelProtocol
    private lazy var dataSource = AnimeDataSource(tableView: tableView)
    
    var subscriptions = Set<AnyCancellable>()
    var trendingMangas: [TitleInfo] = []
    var alltimeMangas: [TitleInfo] = []
    
    enum Section: CaseIterable {
        case trending
        case alltime
    }
    
    private let refreshText = "Fetching new anime titles"
    private var refreshControl = UIRefreshControl()
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.separatorColor = .black
        table.register(BaseTableViewCell.self, forCellReuseIdentifier: BaseTableViewCell.identifier)
        table.rowHeight = 168// 156+6+6
        
        refreshControl.tintColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        let attributedString = NSMutableAttributedString(string: refreshText)
        attributedString.addAttributes([.foregroundColor : #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)], range: (attributedString.string as NSString).range(of: refreshText))
        refreshControl.attributedTitle = attributedString
        table.refreshControl = refreshControl
        
        
        return table
    }()
    
    init(coordinator: AppFlowCoordinatorProtocol, viewModel: AnimePageViewModelProtocol) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindViewModel()
        
        firstLoadView()
    }
    
    private func bindViewModel() {
        
        viewModel.isTrendingLoading
            .combineLatest(viewModel.isAlltimeLoading)
            .receive(on: RunLoop.main)
            .sink {[unowned self] (isLoadingTrending, isLoadingAlltime) in
                if isLoadingTrending || isLoadingAlltime {
                    self.tableView.refreshControl?.beginRefreshing()
                } else {
                    self.tableView.refreshControl?.endRefreshing()
                }
            }.store(in: &subscriptions)
        
        viewModel.trendingDataSource
            .receive(on: RunLoop.main)
            .sink {[unowned self] data in
                self.trendingMangas = data
                self.applySnapshot()
            }.store(in: &subscriptions)
        
        viewModel.alltimeDataSource
            .receive(on: RunLoop.main)
            .sink {[unowned self] data in
                self.alltimeMangas.append(contentsOf: data)
                self.alltimeMangas.removeAll { titleInfo in
                    return self.trendingMangas.contains(titleInfo)
                }
                self.applySnapshot()
            }.store(in: &subscriptions)
    }
    
    private func firstLoadView() {
        tableView.refreshControl?.addAction(
            UIAction(title: "RefteshTable", handler: {[unowned self] _ in
                self.viewModel.fetchTrendingData()
                self.viewModel.fetchAlltimeData()
            }),
            for: .valueChanged)
//        viewModel.fetchTrendingData()
//        viewModel.fetchAlltimeData()
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, TitleInfo>()
        snapshot.appendSections([.trending, .alltime])
        snapshot.appendItems(trendingMangas, toSection: .trending)
        snapshot.appendItems(alltimeMangas, toSection: .alltime)
        dataSource.apply(snapshot)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
  
}

extension AnimePageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = .label
        header.textLabel?.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        header.textLabel?.frame = header.bounds
        header.textLabel?.textAlignment = .center
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row + 3) == tableView.numberOfRows(inSection: 1) {
            viewModel.fetchNextPage()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let titleInfo: TitleInfo
        switch indexPath.section {
        case 0:
            titleInfo = trendingMangas[indexPath.item]
        case 1:
            titleInfo = alltimeMangas[indexPath.item]
        default:
            fatalError("Unpossible section in table")
        }
        coordinator?.showDetailInfoPage(titleInfo: titleInfo)
    }
}
