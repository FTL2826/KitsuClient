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
    
    private var input: PassthroughSubject<MangaPageViewModel.Input, Never> = .init()
    private var subscriptions = Set<AnyCancellable>()
    private var nextPageLink: String?
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
        input.send(.viewDidLoad)
        
    }
    
    private func bindViewModel() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: RunLoop.main)
            .sink { [unowned self] event in
            switch event {
            case .loadTrending(let isLoading):
                print("isTrendingLoading: ", isLoading)
            case .fetchTrendigDidSucceed(let info):
                
                var snapshot = self.dataSource.snapshot()
                snapshot.appendSections([.trending, .alltime])
                snapshot.appendItems(info, toSection: .trending)
                self.dataSource.apply(snapshot)
                
                input.send(.paginationRequest(nextPageLink: API.Types.Endpoint.manga(offset: "0").url.absoluteString))
                
            case .fetchNextPageDidSucceed(let info, let nextPageLink):
                self.nextPageLink = nextPageLink
                
                var snapshot = self.dataSource.snapshot()
                snapshot.appendItems(info, toSection: .alltime)
                self.dataSource.apply(snapshot)
                
            default:
                print("default")
            }
        }.store(in: &subscriptions)
    }
    
//    private func applySnapshot() {
//        var snapshot = dataSource.snapshot()
//        snapshot.appendSections([.trending, .alltime])
//        snapshot.appendItems(trendingMangas, toSection: .trending)
//        snapshot.appendItems(alltimeMangas, toSection: .alltime)
//        dataSource.apply(snapshot)
//    }
//
//    private func nextPageSnapshot() {
//        var snapshot = dataSource.snapshot()
//        snapshot.appendItems(nextpage, toSection: .alltime)
//        dataSource.apply(snapshot)
//    }
    
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
            guard let nextPageLink = nextPageLink else { return }
            input.send(.paginationRequest(nextPageLink: nextPageLink))
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let titleInfo = dataSource.itemIdentifier(for: indexPath) else { return }
        coordinator?.showDetailInfoPage(titleInfo: titleInfo)
    }
}
