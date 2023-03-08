//
//  MangaFeedViewController.swift
//  KitsuClient
//
//  Created by Александр Харин on /53/23.
//

import UIKit

class MangaFeedViewController: BaseFeedViewController {
    
    var viewModel: MangaFeedViewModelProtocol?
    
    init(
        viewModel: MangaFeedViewModelProtocol
    ) {
        super.init(viewModel: viewModel)
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
        
        
        cell.textLabel?.text = viewModel?.getMangaTitle(index: indexPath.row, segment: segment)
        
        return cell
    }
    
}
