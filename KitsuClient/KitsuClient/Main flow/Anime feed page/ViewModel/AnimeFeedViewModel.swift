//
//  AnimeFeedViewModel.swift
//  KitsuClient
//
//  Created by Александр Харин on /73/23.
//

import Foundation

class AnimeFeedViewModel: BaseFeedViewModel, AnimeFeedViewModelProtocol {
    
    
    
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
    
    func getAnimeTitle(index: Int, segment: Segments) -> TitleInfo {
        switch segment {
        case .trending:
            return trendingDataSource[index]
        case .alltime:
            return alltimeDataSource[index]
        }
    }
    
    //MARK: - trending
    override func fetchTrendingData() {
        guard isTrendingLoading.value == false else { return }
        isTrendingLoading.value = true
        
        apiClient.get(.animeTrending) { [weak self] (result: Result<API.Types.Response.TrendingAnimeSearch, API.Types.Error>) in
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
    
    private func mapTrendingData(_ results: API.Types.Response.TrendingAnimeSearch) -> [TitleInfo] {
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
        
        apiClient.get(.anime(offset: "0")) { [weak self] (result: Result<API.Types.Response.AnimeSearch, API.Types.Error>) in
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
    
    private func mapAlltimeData(_ results: API.Types.Response.AnimeSearch) -> [TitleInfo] {
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
