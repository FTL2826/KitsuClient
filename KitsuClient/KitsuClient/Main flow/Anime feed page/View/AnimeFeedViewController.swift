//
//  AnimeFeedViewController.swift
//  KitsuClient
//
//  Created by Александр Харин on /43/23.
//

import UIKit

class AnimeFeedViewController: BaseFeedViewController {
    
    var viewModel: AnimeFeedViewModelProtocol?
    
    let trendingTableRefresherText = "Fetching trending anime titles"
    let alltimeTableRefresherText = "Fetching all-time anime titles"
    
    init(
        viewModel: AnimeFeedViewModelProtocol
    ) {
        super.init(viewModel: viewModel,
                   trendingTableRefresherText: trendingTableRefresherText,
                   alltimeTableRefresherText: alltimeTableRefresherText)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
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
        
        let cell = UITableViewCell()
        cell.backgroundColor = .systemBackground
        
        
        cell.textLabel?.text = viewModel?.getAnimeTitle(index: indexPath.row, segment: segment)
        
        return cell
    }
    
}
