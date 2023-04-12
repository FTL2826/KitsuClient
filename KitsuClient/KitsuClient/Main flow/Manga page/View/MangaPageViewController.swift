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
        view.hidesWhenStopped = true
        return view
    }()
    private lazy var footerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        view.backgroundColor = .systemBackground
        return view
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
    
    deinit {
        print("MangaPageViewController was destroyed")
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
                input.send(.paginationRequest(nextPageLink: API.Types.Endpoint.manga(offset: "0").url.absoluteString))
            case .fetchNextPageDidSucceed(let info, let nextPageLink):
                self.nextPageLink = nextPageLink
                var snapshot = self.dataSource.snapshot()
                snapshot.appendItems(info, toSection: .alltime)
                self.dataSource.apply(snapshot)
            case .loadNextPage(let isLoading):
//                print("loading next page...: ", isLoading)
                if isLoading {
                    activityIndicator.startAnimating()
                } else {
                    activityIndicator.stopAnimating()
                }
            }
        }.store(in: &subscriptions)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.tableFooterView = footerView
        
        footerView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            activityIndicator.heightAnchor.constraint(equalToConstant: 88),
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
