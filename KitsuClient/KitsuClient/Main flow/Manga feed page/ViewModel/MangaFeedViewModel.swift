//
//  MangaFeedViewModel.swift
//  KitsuClient
//
//  Created by Александр Харин on /83/23.
//

import Foundation

class MangaFeedViewModel: BaseFeedViewModel, MangaFeedViewModelProtocol {
    
    var apiClient: APIClientProtocol
    
    var trendingDataSource = [TitleInfo]()
    var alltimeDataSource = [TitleInfo]()
    
    var trendingCount = Dynamic(0)
    var alltimeCount = Dynamic(0)
    
    init(
        apiClient: APIClientProtocol
    ) {
        self.apiClient = apiClient
    }
    
    //MARK: - table view delegates
    override func numbersOfRowsInSection(section: Int, segment: Segments) -> Int {
        if section == 0 {
            switch segment {
            case .trending:
                return trendingCount.value
            case .alltime:
                return alltimeCount.value
            }
        } else {
            return 0
        }
    }
    
    func getMangaTitle(index: Int, segment: Segments) -> TitleInfo? {
        switch segment {
        case .trending:
            guard index < trendingDataSource.count else { return nil}
            return trendingDataSource[index]
        case .alltime:
            guard index < alltimeDataSource.count else { return nil}
            return alltimeDataSource[index]
        }
    }
    
    //MARK: - trending
    override func fetchTrendingData() {
        guard isTrendingLoading.value == false else { return }
        isTrendingLoading.value = true
        
        apiClient.get(.mangaTrending) { [weak self] (result: Result<API.Types.Response.TrendingMangaSearch, API.Types.Error>) in
            guard let self = self else { return }
            
            self.isTrendingLoading.value = false
            switch result {
            case .success(let success):
                self.trendingDataSource = self.mapTrendingData(success)
                self.trendingCount.value = self.trendingDataSource.count
            case .failure(let failure):
                print("Fetch trending manga error:", failure.localizedDescription)
            }
        }
    }
    
    private func mapTrendingData(_ results: API.Types.Response.TrendingMangaSearch) -> [TitleInfo] {
        var localResults = [TitleInfo]()
        
        for result in results.data {
            localResults.append(TitleInfo(
                id: result.id,
                canonicalTitle: result.attributes.canonicalTitle,
                startDate: result.attributes.startDate,
                favouritesCount: result.attributes.favoritesCount,
                averageRating: result.attributes.averageRating,
                posterImageTinyURL: result.attributes.posterImage.tiny,
                posterImageOriginalURL: result.attributes.posterImage.original))
        }
        
        return localResults
    }
    
    //MARK: - All-time
    override func fetchAlltimeData() {
        guard isAlltimeLoading.value == false else { return }
        isAlltimeLoading.value = true
        
        apiClient.get(.manga(offset: "0")) { [weak self] (result: Result<API.Types.Response.MangaSearch, API.Types.Error>) in
            guard let self = self else { return }
            self.isAlltimeLoading.value = false
            switch result {
            case .success(let success):
                self.alltimeDataSource = self.mapAlltimeData(success)
                self.alltimeCount.value = self.alltimeDataSource.count
            case .failure(let failure):
                print("Fetch trending manga error:", failure.localizedDescription)
            }
        }
    }
    
    private func mapAlltimeData(_ results: API.Types.Response.MangaSearch) -> [TitleInfo] {
        var localResults = [TitleInfo]()
        
        for result in results.data {
            localResults.append(TitleInfo(
                id: result.id,
                canonicalTitle: result.attributes.canonicalTitle,
                startDate: result.attributes.startDate,
                favouritesCount: result.attributes.favoritesCount,
                averageRating: result.attributes.averageRating,
                posterImageTinyURL: result.attributes.posterImage.tiny,
                posterImageOriginalURL: result.attributes.posterImage.original))
        }
        
        return localResults
    }
    
    
    
    
}
