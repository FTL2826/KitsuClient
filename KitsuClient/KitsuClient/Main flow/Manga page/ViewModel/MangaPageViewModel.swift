//
//  MangaPageViewModel.swift
//  KitsuClient
//
//  Created by Александр Харин on /303/23.
//

import Foundation
import Combine

class MangaPageViewModel: MangaPageViewModelProtocol {
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
        
        apiClient.get(.mangaTrending)
            .sink(receiveCompletion: { [unowned self] in
                if case .failure(let fail) = $0 {
                    self.output.send(.fetchDidFail(error: .generic(reason: fail.localizedDescription)))
                }
            }, receiveValue: { (value: API.Types.Response.TrendingMangaSearch) in
                self.output.send(.loadTrending(isLoading: false))
                let mappedData = self.mapTrendingData(value)
                self.output.send(.fetchTrendigDidSucceed(info: mappedData))
            })
            .store(in: &subscriptions)
    }
    
    private func mapTrendingData(_ results: API.Types.Response.TrendingMangaSearch) -> [TitleInfo] {
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
                chapterCount: result.attributes.chapterCount,
                volumeCount: result.attributes.volumeCount,
                episodesCount: nil,
                episodeLenght: nil))
        }
        
        return localResults
    }
    
    //MARK: - All-time
    func fetchNextPage(_ link: String) {
        output.send(.loadNextPage(isLoading: true))
        
        apiClient.get(.nextPage(link: link))
            .sink {
                if case .failure(let fail) = $0 {
                    self.output.send(.fetchDidFail(error: .generic(reason: fail.localizedDescription)))
                }
            } receiveValue: { [unowned self] (value: API.Types.Response.MangaSearch) in
                output.send(.loadNextPage(isLoading: false))
                let mappedResponse = self.mapAlltimeData(value)
                self.output.send(.fetchNextPageDidSucceed(info: mappedResponse.data, nextPageLink: mappedResponse.nextLink))
            }.store(in: &subscriptions)
    }
    
    private func mapAlltimeData(_ results: API.Types.Response.MangaSearch) -> (data: [TitleInfo], nextLink: String) {
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
                
                chapterCount: result.attributes.chapterCount,
                volumeCount: result.attributes.volumeCount,
                episodesCount: nil,
                episodeLenght: nil))
        }
        
        return (data: localResults, nextLink: results.links.next)
    }
    
}
