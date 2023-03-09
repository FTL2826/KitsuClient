//
//  MangaFeedViewModelProtocol.swift
//  KitsuClient
//
//  Created by Александр Харин on /83/23.
//

import Foundation

protocol MangaFeedViewModelProtocol: BaseFeedViewModelProtocol {
    
    var apiClient: APIClientProtocol { get }
    
    var trendingCount: Dynamic<Int> { get }
    var alltimeCount: Dynamic<Int> { get }
    
    func getMangaTitle(index: Int, segment: Segments) -> TitleInfo?
}
