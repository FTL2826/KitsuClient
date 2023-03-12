//
//  MangaFeedViewController.swift
//  KitsuClient
//
//  Created by Александр Харин on /53/23.
//

import UIKit

class MangaFeedViewController: BaseFeedViewController {
    
    var viewModel: MangaFeedViewModelProtocol?
    weak var coordinator: AppFlowCoordinatorProtocol?
    
    let trendingTableRefresherText = "Fetching trending manga titles"
    let alltimeTableRefresherText = "Fetching all-time manga titles"
    
    init(
        viewModel: MangaFeedViewModelProtocol,
        coordinator: AppFlowCoordinatorProtocol
    ) {
        super.init(viewModel: viewModel,
                   trendingTableRefresherText: trendingTableRefresherText,
                   alltimeTableRefresherText: alltimeTableRefresherText)
        self.viewModel = viewModel
        self.coordinator = coordinator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - bind view model
    override func bindViewModel() {
        super.bindViewModel()
        
        viewModel?.trendingCount.bind(listener: { [weak self] _ in
            self?.reloadTrendingTable()
        })
        
        viewModel?.alltimeCount.bind(listener: { [weak self] _ in
            self?.reloadAlltimeTable()
        })
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BaseTableViewCell.identifier, for: indexPath) as? BaseTableViewCell else {
                    fatalError("Could not dequeue feed table cell")
                }
        
        guard let titleInfo = viewModel?.getMangaTitle(index: indexPath.row, segment: segment) else {
            return cell
        }
        cell.configureCell(viewModel:
                            BaseTableViewCellViewModel(titleInfo: titleInfo,
                                                       pictureLoader: PictureLoader.shared))
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let titleInfo = viewModel?.getMangaTitle(index: indexPath.row, segment: segment) {
            coordinator?.showDetailInfoPage(titleInfo: titleInfo)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row + 3) == tableView.numberOfRows(inSection: 0) {
            viewModel?.fetchNextPage()
        }
    }
    
}
