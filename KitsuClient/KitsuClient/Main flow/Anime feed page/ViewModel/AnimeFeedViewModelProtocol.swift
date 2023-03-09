//
//  AnimeFeedViewModelProtocol.swift
//  KitsuClient
//
//  Created by Александр Харин on /73/23.
//

import Foundation

enum Segments: String {
    case trending = "Trending"
    case alltime = "All-time"
}

protocol AnimeFeedViewModelProtocol: BaseFeedViewModelProtocol {
    
    var apiClient: APIClientProtocol { get }
    
    var trendingCount: Dynamic<Int> { get }
    var alltimeCount: Dynamic<Int> { get }
    
    func getAnimeTitle(index: Int, segment: Segments) -> TitleInfo
}
