//
//  APIClientMock.swift
//  KitsuClientTests
//
//  Created by Александр Харин on /143/23.
//

import Foundation
@testable import KitsuClient

class APIClientMock<Request, Response>: APIClientProtocol {
    
    private(set) var fetchWasCalled = 0
    var callbackStub: Bool?
    
    func fetch<Request, Response>(
        _ endpoint: KitsuClient.API.Types.Endpoint,
        method: KitsuClient.API.Types.Method,
        body: Request?,
        then callback: ((Result<Response, KitsuClient.API.Types.Error>) -> ())?
    ) where Request : Encodable, Response : Decodable {
        
        fetchWasCalled += 1
        if callbackStub ?? false {
//            callback?(.success(<#T##Decodable#>))
        } else {
            callback?(.failure(.internal(reason: "mock api failure")))
        }
        
    }
    
    func get<Response>(
        _ endpoint: KitsuClient.API.Types.Endpoint,
        then callback: ((Result<Response, KitsuClient.API.Types.Error>) -> ())?
    ) where Response : Decodable {
        let body: API.Types.Request.Empty? = nil
        fetch(endpoint, method: .get, body: body) { result in
            callback?(result)
        }
    }
    
    
}
