//
//  MangaDataSource.swift
//  KitsuClient
//
//  Created by Александр Харин on /303/23.
//

import Foundation
import UIKit

class MangaDataSource: UITableViewDiffableDataSource<MangaPageViewController.Section, TitleInfo> {
    
    init(tableView: UITableView) {
        super.init(tableView: tableView) { tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BaseTableViewCell.identifier, for: indexPath) as? BaseTableViewCell else {
                fatalError("Could not dequeue feed table cell")
            }
            let cellViewModel = BaseTableViewCellViewModel(titleInfo: item, pictureLoader: PictureLoader.shared)
            cell.configureCell(viewModel: cellViewModel)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let header = MangaPageViewController.Section.allCases[section]
        switch header {
        case .trending:
            return "Manga in trend"
        case .alltime:
            return "All time list"
        }
    }
    
    
    
    
    
}
