//
//  BaseFeedViewModel.swift
//  KitsuClient
//
//  Created by Александр Харин on /83/23.
//

import Foundation

protocol BaseFeedViewModelProtocol: AnyObject {
    var isTrendingLoading: Dynamic<Bool> { get }
    var isAlltimeLoading: Dynamic<Bool> { get }
    
    func numbersOfSections(segment: Segments) -> Int
    func numbersOfRowsInSection(section: Int, segment: Segments) -> Int
    func fetchTrendingData()
    func fetchAlltimeData()
    
}

class BaseFeedViewModel {
    var isTrendingLoading = Dynamic(false)
    var isAlltimeLoading = Dynamic(false)
    
    func numbersOfSections(segment: Segments) -> Int {
        switch segment {
        case .trending:
            return 1
        case .alltime:
            return 1
        }
    }
    
    func numbersOfRowsInSection(section: Int, segment: Segments) -> Int {
        if section == 0 {
            switch segment {
            case .trending:
                return 10
            case .alltime:
                return 20
            }
        } else {
            return 0
        }
        
    }
    
    func fetchTrendingData() {
        guard isTrendingLoading.value == false else { return }
        isTrendingLoading.value = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.isTrendingLoading.value = false
        }
    }
    
    func fetchAlltimeData() {
        guard isAlltimeLoading.value == false else { return }
        isAlltimeLoading.value = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.isAlltimeLoading.value = false
        }
    }
    
}
