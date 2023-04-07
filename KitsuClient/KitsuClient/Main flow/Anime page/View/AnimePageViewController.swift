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
    
    private var input: PassthroughSubject<AnimePageViewModel.Input, Never> = .init()
    private var subscriptions = Set<AnyCancellable>()
    private var nextPageLink: String?
    
    enum Section: CaseIterable {
        case trending
        case alltime
    }
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.separatorColor = .black
        table.register(BaseTableViewCell.self, forCellReuseIdentifier: BaseTableViewCell.identifier)
        table.rowHeight = 168// 156+6+6
        table.isPagingEnabled = true
        return table
    }()
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .black
        return view
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
        input.send(.viewDidLoad)
        
    }
    
    deinit {
        print("AnimePageViewController was destroyed")
    }
    
    private func bindViewModel() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: RunLoop.main)
            .sink { [unowned self] event in
            switch event {
            case .loadTrending(let isLoading):
                if isLoading {
                    activityIndicator.startAnimating()
                } else {
                    activityIndicator.stopAnimating()
                }
            case .fetchDidFail(let error):
                print("Completion error for fetchData method in MangaPageViewModel: ", error.localizedDescription)
            case .fetchTrendigDidSucceed(let info):
                var snapshot = self.dataSource.snapshot()
                snapshot.appendSections([.trending, .alltime])
                snapshot.appendItems(info, toSection: .trending)
                self.dataSource.apply(snapshot)
                input.send(.paginationRequest(nextPageLink: API.Types.Endpoint.anime(offset: "0").url.absoluteString))
            case .fetchNextPageDidSucceed(let info, let nextPageLink):
                self.nextPageLink = nextPageLink
                var snapshot = self.dataSource.snapshot()
                snapshot.appendItems(info, toSection: .alltime)
                self.dataSource.apply(snapshot)
            case .loadNextPage(let isLoading):
                print("loading next page...: ", isLoading)
            }
        }.store(in: &subscriptions)
        
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            activityIndicator.heightAnchor.constraint(equalToConstant: 200),
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
            guard let nextPageLink = nextPageLink else { return }
            input.send(.paginationRequest(nextPageLink: nextPageLink))
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let titleInfo = dataSource.itemIdentifier(for: indexPath) else { return }
        coordinator?.showDetailInfoPage(titleInfo: titleInfo)
    }
}
