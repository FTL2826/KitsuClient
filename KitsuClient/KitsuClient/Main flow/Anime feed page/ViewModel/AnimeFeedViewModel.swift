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
   
    private var nextPageLink: String?
    
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
    
    func getAnimeTitle(index: Int, segment: Segments) -> TitleInfo? {
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
                type: result.type,
                canonicalTitle: result.attributes.canonicalTitle,
                startDate: result.attributes.startDate,
                endDate: result.attributes.endDate,
                favouritesCount: result.attributes.favoritesCount,
                averageRating: result.attributes.averageRating,
                ageRatingGuide: result.attributes.ageRatingGuide,
                status: result.attributes.status,
                synopsis: result.attributes.synopsis,
                posterImageTinyURL: result.attributes.posterImage.tiny,
                posterImageSmallURL: result.attributes.posterImage.small,
                posterImageOriginalURL: result.attributes.posterImage.original,
                chapterCount: nil,
                volumeCount: nil,
                episodesCount: result.attributes.episodeCount,
                episodeLenght: result.attributes.episodeLength))
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
        nextPageLink = results.links.next
        
        for result in results.data {
            localResults.append(TitleInfo(
                id: result.id,
                type: result.type,
                canonicalTitle: result.attributes.canonicalTitle,
                startDate: result.attributes.startDate,
                endDate: result.attributes.endDate,
                favouritesCount: result.attributes.favoritesCount,
                averageRating: result.attributes.averageRating,
                ageRatingGuide: result.attributes.ageRatingGuide,
                status: result.attributes.status,
                synopsis: result.attributes.synopsis,
                posterImageTinyURL: result.attributes.posterImage.tiny,
                posterImageSmallURL: result.attributes.posterImage.small,
                posterImageOriginalURL: result.attributes.posterImage.original,
                
                chapterCount: nil,
                volumeCount: nil,
                episodesCount: result.attributes.episodeCount,
                episodeLenght: result.attributes.episodeLength))
        }
        
        return localResults
    }
    
    func fetchNextPage() {
        guard let nextPageLink = nextPageLink,isAlltimeLoading.value == false else { return }
        isAlltimeLoading.value = true
        apiClient.get(.nextPage(link: nextPageLink)) { [weak self] (result: Result<API.Types.Response.AnimeSearch, API.Types.Error>) in
            guard let self = self else { return }
            self.isAlltimeLoading.value = false
            
            switch result {
            case .success(let success):
                print("next page success count:", success.data.count)
                self.alltimeDataSource.append(contentsOf: self.mapAlltimeData(success))
                self.alltimeCount.value = self.alltimeDataSource.count
            case .failure(let failure):
                print("Fetch all-time next page anime error:", failure.localizedDescription)
            }
        }
    }
    
    
    
}
