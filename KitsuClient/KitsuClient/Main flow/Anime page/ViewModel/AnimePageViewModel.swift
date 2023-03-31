//
//  AnimePageViewModel.swift
//  KitsuClient
//
//  Created by Александр Харин on /313/23.
//

import Foundation
import Combine

class AnimePageViewModel: AnimePageViewModelProtocol {
    
    var apiClient: APIClientProtocol
    
    var isTrendingLoading = CurrentValueSubject<Bool, Never>(false)
    var isAlltimeLoading = CurrentValueSubject<Bool, Never>(false)
    var trendingDataSource = PassthroughSubject<[TitleInfo], Never>()
    var alltimeDataSource = PassthroughSubject<[TitleInfo], Never>()
    
    
    private var nextPageLink: String?
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    
    //MARK: - trending
    func fetchTrendingData() {
        guard isTrendingLoading.value == false else { return }
        isTrendingLoading.send(true)
        
        apiClient.get(.animeTrending) { [weak self] (result: Result<API.Types.Response.TrendingAnimeSearch, API.Types.Error>) in
            guard let self = self else { return }
            
            self.isTrendingLoading.send(false)
            switch result {
            case .success(let success):
                self.trendingDataSource.send(self.mapTrendingData(success))
//                self.trendingDataSource = self.mapTrendingData(success)
//                self.trendingCount.value = self.trendingDataSource.count
            case .failure(let failure):
                print("Fetch trending manga error:", failure.localizedDescription)
            }
        }
    }
    
    private func mapTrendingData(_ results: API.Types.Response.TrendingAnimeSearch) -> [TitleInfo] {
        var localResults = [TitleInfo]()
        
        for result in results.data {
            localResults.append(TitleInfo(
                internalID: UUID().uuidString,
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
    func fetchAlltimeData() {
        guard isAlltimeLoading.value == false else { return }
        isAlltimeLoading.send(true)
        
        apiClient.get(.anime(offset: "0")) { [weak self] (result: Result<API.Types.Response.AnimeSearch, API.Types.Error>) in
            guard let self = self else { return }
            self.isAlltimeLoading.send(false)
            switch result {
            case .success(let success):
                self.alltimeDataSource.send(self.mapAlltimeData(success))
//                self.alltimeDataSource = self.mapAlltimeData(success)
//                self.alltimeCount.value = self.alltimeDataSource.count
            case .failure(let failure):
                print("Fetch all-time manga error:", failure.localizedDescription)
            }
        }
    }
    
    private func mapAlltimeData(_ results: API.Types.Response.AnimeSearch) -> [TitleInfo] {
        var localResults = [TitleInfo]()
        nextPageLink = results.links.next
        
        for result in results.data {
            localResults.append(TitleInfo(
                internalID: UUID().uuidString,
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
        isAlltimeLoading.send(true)
        apiClient.get(.nextPage(link: nextPageLink)) { [weak self] (result: Result<API.Types.Response.AnimeSearch, API.Types.Error>) in
            guard let self = self else { return }
            self.isAlltimeLoading.send(false)
            
            switch result {
            case .success(let success):
                print("next page success count:", success.data.count)
                self.alltimeDataSource.send(self.mapAlltimeData(success))
//                self.alltimeDataSource.append(contentsOf: self.mapAlltimeData(success))
//                self.alltimeCount.value = self.alltimeDataSource.count
            case .failure(let failure):
                print("Fetch all-time next page manga error:", failure.localizedDescription)
            }
        }
    }
    
}
