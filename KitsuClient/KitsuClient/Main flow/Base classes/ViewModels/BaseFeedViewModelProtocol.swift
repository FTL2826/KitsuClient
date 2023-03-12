//
//  BaseFeedViewModelProtocol.swift
//  KitsuClient
//
//  Created by Александр Харин on /103/23.
//


protocol BaseFeedViewModelProtocol: AnyObject {
    var isTrendingLoading: Dynamic<Bool> { get }
    var isAlltimeLoading: Dynamic<Bool> { get }
    
    func numbersOfSections(segment: Segments) -> Int
    func numbersOfRowsInSection(section: Int, segment: Segments) -> Int
    func fetchTrendingData()
    func fetchAlltimeData()
    
}
