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
    
    private var output: PassthroughSubject<Output, Never> = .init()
    private var subscriptions = Set<AnyCancellable>()
    
    enum Input {
        case viewDidLoad
        case paginationRequest(nextPageLink: String)
    }
    
    enum Output {
        case loadTrending(isLoading: Bool)
        case fetchTrendigDidSucceed(info: [TitleInfo])
        
        case loadNextPage(isLoading: Bool)
        case fetchNextPageDidSucceed(info: [TitleInfo], nextPageLink: String)
        
        case fetchDidFail(error: API.Types.Error)
    }
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    //MARK: - transform
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [unowned self] event in
            switch event {
            case .viewDidLoad:
                self.fetchTrendingData()
            case .paginationRequest(let nextPageLink):
                fetchNextPage(nextPageLink)
            }
        }.store(in: &subscriptions)
        
        return output.eraseToAnyPublisher()
    }
    
    //MARK: - trending
    func fetchTrendingData() {
        output.send(.loadTrending(isLoading: true))
        
        apiClient.getCombine(.animeTrending)
            .sink(receiveCompletion: { [unowned self] in
                if case .failure(let fail) = $0 {
                    self.output.send(.fetchDidFail(error: .generic(reason: fail.localizedDescription)))
                }
            }, receiveValue: { (value: API.Types.Response.TrendingAnimeSearch) in
                self.output.send(.loadTrending(isLoading: false))
                let mappedData = self.mapTrendingData(value)
                self.output.send(.fetchTrendigDidSucceed(info: mappedData))
            })
            .store(in: &subscriptions)
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
    func fetchNextPage(_ link: String) {
        output.send(.loadNextPage(isLoading: true))
        
        apiClient.getCombine(.nextPage(link: link))
            .sink {
                if case .failure(let fail) = $0 {
                    self.output.send(.fetchDidFail(error: .generic(reason: fail.localizedDescription)))
                }
            } receiveValue: { [unowned self] (value: API.Types.Response.AnimeSearch) in
                output.send(.loadNextPage(isLoading: false))
                let mappedResponse = self.mapAlltimeData(value)
                self.output.send(.fetchNextPageDidSucceed(info: mappedResponse.data, nextPageLink: mappedResponse.nextLink))
            }.store(in: &subscriptions)
    }
    
    private func mapAlltimeData(_ results: API.Types.Response.AnimeSearch) -> (data: [TitleInfo], nextLink: String) {
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
        
        return (data: localResults, nextLink: results.links.next)
    }
    
}
