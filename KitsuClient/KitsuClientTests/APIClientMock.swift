//
//  APIClientMock.swift
//  KitsuClientTests
//
//  Created by Александр Харин on /143/23.
//

import Foundation
import Combine
@testable import KitsuClient

class APIClientMock: APIClientProtocol {

    private(set) var fetchWasCalled = 0
    var mangaTrendResult: Result<KitsuClient.API.Types.Response.TrendingMangaSearch, KitsuClient.API.Types.Error>?
    var mangaAlltimeResult: Result<KitsuClient.API.Types.Response.MangaSearch, KitsuClient.API.Types.Error>?
    
    var animeTrendResult: Result<KitsuClient.API.Types.Response.TrendingAnimeSearch, KitsuClient.API.Types.Error>?
    var animeAlltimeResult: Result<KitsuClient.API.Types.Response.AnimeSearch, KitsuClient.API.Types.Error>?
    
    func fetch<Request, Response>(_ endpoint: KitsuClient.API.Types.Endpoint, method: KitsuClient.API.Types.Method, body: Request?) -> AnyPublisher<Response, KitsuClient.API.Types.Error> where Request : Encodable, Response : Decodable {
        
        fetchWasCalled += 1
        
        switch mangaTrendResult {
        case .failure(let error):
            return Fail(error: error)
                .eraseToAnyPublisher()
        case .success(let success):
            return Just(success as! Response)
                .setFailureType(to: KitsuClient.API.Types.Error.self)
                .eraseToAnyPublisher()
        case .none:
            break
        }
        switch mangaAlltimeResult {
        case .failure(let error):
            return Fail(error: error)
                .eraseToAnyPublisher()
        case .success(let success):
            return Just(success as! Response)
                .setFailureType(to: KitsuClient.API.Types.Error.self)
                .eraseToAnyPublisher()
        case .none:
            break
        }
        
        switch animeTrendResult {
        case .failure(let error):
            return Fail(error: error)
                .eraseToAnyPublisher()
        case .success(let success):
            return Just(success as! Response)
                .setFailureType(to: KitsuClient.API.Types.Error.self)
                .eraseToAnyPublisher()
        case .none:
            break
        }
        switch animeAlltimeResult {
        case .failure(let error):
            return Fail(error: error)
                .eraseToAnyPublisher()
        case .success(let success):
            return Just(success as! Response)
                .setFailureType(to: KitsuClient.API.Types.Error.self)
                .eraseToAnyPublisher()
        case .none:
            break
        }
        
        return Empty().eraseToAnyPublisher()
    }
    
    func get<Response>(_ endpoint: KitsuClient.API.Types.Endpoint) -> AnyPublisher<Response, KitsuClient.API.Types.Error> where Response : Decodable {
        let body: API.Types.Request.Empty? = nil
        return fetch(endpoint, method: .get, body: body)
    }
    
    
}
