//
//  MangaPageViewController.swift
//  KitsuClient
//
//  Created by Александр Харин on /303/23.
//

import Foundation
import UIKit
import Combine



class MangaPageViewController: UIViewController {
    
    weak var coordinator: AppFlowCoordinatorProtocol?
    var viewModel: MangaPageViewModelProtocol
    private lazy var dataSource = MangaDataSource(tableView: tableView)
    
    var subscriptions = Set<AnyCancellable>()
    var trendingMangas: [TitleInfo] = []
    var alltimeMangas: [TitleInfo] = []
    var nextpage: [TitleInfo] = []
    
    enum Section: CaseIterable {
        case trending
        case alltime
    }
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.separatorColor = .black
        table.register(BaseTableViewCell.self, forCellReuseIdentifier: BaseTableViewCell.identifier)
        table.rowHeight = 168// 156+6+6
        return table
    }()
    
    init(coordinator: AppFlowCoordinatorProtocol, viewModel: MangaPageViewModelProtocol) {
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
                    
                } else {
                    
                }
            }.store(in: &subscriptions)
        
        viewModel.alltimeDataSource
            .zip(viewModel.trendingDataSource)
            .receive(on: RunLoop.main)
            .sink {[unowned self] (alltimeData, trendingData) in
                self.trendingMangas = trendingData
                self.alltimeMangas = alltimeData
                self.applySnapshot()
            }.store(in: &subscriptions)
        
        viewModel.nextPageDataSource
            .receive(on: RunLoop.main)
            .sink {[unowned self] nextPage in
                var appendix = nextPage
                appendix.removeAll { title in
                    self.trendingMangas.contains(title)
                }
                self.nextpage.append(contentsOf: appendix)
                self.nextPageSnapshot()
            }.store(in: &subscriptions)
    }
    
    private func firstLoadView() {
        viewModel.fetchTrendingData()
        viewModel.fetchAlltimeData()
    }
    
    private func applySnapshot() {
        var snapshot = dataSource.snapshot()
        snapshot.appendSections([.trending, .alltime])
        snapshot.appendItems(trendingMangas, toSection: .trending)
        snapshot.appendItems(alltimeMangas, toSection: .alltime)
        dataSource.apply(snapshot)
    }
    
    private func nextPageSnapshot() {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems(nextpage, toSection: .alltime)
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

extension MangaPageViewController: UITableViewDelegate {
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
        guard let titleInfo = dataSource.itemIdentifier(for: indexPath) else { return }
        coordinator?.showDetailInfoPage(titleInfo: titleInfo)
    }
}
