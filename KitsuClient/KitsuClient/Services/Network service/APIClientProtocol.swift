//
//  APIClientProtocol.swift
//  KitsuClient
//
//  Created by Александр Харин on /282/23.
//

import Foundation
import Combine

protocol APIClientProtocol: AnyObject {
  
    func fetchCombine<Request: Encodable, Response: Decodable>(_ endpoint: API.Types.Endpoint,
                                                               method: API.Types.Method,
                                                               body: Request?) -> AnyPublisher<Response, API.Types.Error>
    
    func getCombine<Response: Decodable>(_ endpoint: API.Types.Endpoint) -> AnyPublisher<Response, API.Types.Error>
}
