//
//  APIClient.swift
//  KitsuClient
//
//  Created by Александр Харин on /282/23.
//

import Foundation
import Combine

extension API {
    
    class Client: APIClientProtocol {
        
        static let shared = Client()
        private let encoder = JSONEncoder()
        private let decoder = JSONDecoder()
        
        func fetch<Request: Encodable, Response: Decodable>(_ endpoint: Types.Endpoint,
                                                                   method: Types.Method = .get,
                                                                   body: Request? = nil) -> AnyPublisher<Response, Types.Error> {
            var urlRequest = URLRequest(url: endpoint.url)
            urlRequest.httpMethod = method.rawValue
            if let body = body {
                do {
                    urlRequest.httpBody = try encoder.encode(body)
                } catch {
                    return Fail(error: .internal(reason: "Could not encode body")).eraseToAnyPublisher()
                }
            }
            
            return URLSession(configuration: .default)
                .dataTaskPublisher(for: urlRequest)
                .tryMap({ (data, response) in
                    if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                        throw API.Types.Error.internal(reason: "Bad response status code")
                    } else {
                        return data
                    }
                })
                .decode(type: Response.self, decoder: decoder)
                .mapError({ error in
                    API.Types.Error.generic(reason: "DataTaskPublisher error: \(error.localizedDescription)")
                })
                .eraseToAnyPublisher()
                
        }
        
        func get<Response: Decodable>(_ endpoint: Types.Endpoint) -> AnyPublisher<Response, Types.Error> {
            let body: Types.Request.Empty? = nil
            return fetch(endpoint, method: .get, body: body)
        }
        
    }
    
}
