//
//  AnimeFeedViewModelProtocol.swift
//  KitsuClient
//
//  Created by Александр Харин on /73/23.
//

import Foundation

protocol AnimeFeedViewModelProtocol: AnyObject {
    
    var apiClient: APIClientProtocol { get }
    
    var isLoading: Dynamic<Bool> { get }
    var dataSource: Dynamic<[AnimeTitle]> { get }
    
    func numbersOfSections() -> Int
    func rowsInSection(_ section: Int) -> Int
    func getAnimeTitle(_ indexPath: IndexPath) -> String
    
    func fetchData()
}
