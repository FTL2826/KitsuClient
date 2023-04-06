//
//  AnimePageViewModelProtocol.swift
//  KitsuClient
//
//  Created by Александр Харин on /313/23.
//

import Foundation
import Combine

protocol AnimePageViewModelProtocol {
    var isTrendingLoading: CurrentValueSubject<Bool, Never> { get }
    var isAlltimeLoading: CurrentValueSubject<Bool, Never> { get }
    var trendingDataSource: PassthroughSubject<[TitleInfo], Never> { get }
    var alltimeDataSource: PassthroughSubject<[TitleInfo], Never> { get }
    
    
    func fetchTrendingData()
    func fetchAlltimeData()
    func fetchNextPage()
}
