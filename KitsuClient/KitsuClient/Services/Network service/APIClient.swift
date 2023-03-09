//
//  APIClient.swift
//  KitsuClient
//
//  Created by Александр Харин on /282/23.
//

import Foundation

extension API {
    
    class Client: APIClientProtocol {
        
        static let shared = Client()
        private let encoder = JSONEncoder()
        private let decoder = JSONDecoder()
        
        func fetch<Request, Response>(_ endpoint: Types.Endpoint,
                                      method: Types.Method = .get,
                                      body: Request? = nil,
                                      then callback: ((Result<Response, Types.Error>) -> ())? = nil
        ) where Request: Encodable, Response: Decodable {
            var urlRequest = URLRequest(url: endpoint.url)
            urlRequest.httpMethod = method.rawValue
            if let body = body {
                do {
                    urlRequest.httpBody = try encoder.encode(body)
                } catch {
                    callback?(.failure(.internal(reason: "Could not encode body")))
                    return
                }
            }
            
            let dataTask = URLSession(configuration: .default)
                .dataTask(with: urlRequest) { [weak self] data, response, error in
                    guard let self = self else { return }
                    if let error = error {
                        print("Fetch error:", error)
                        callback?(.failure(.generic(reason: "Could not fetch data: \(error.localizedDescription)")))
                    } else {
                        if let data = data {
                            do {
                                let result = try self.decoder.decode(Response.self, from: data)
                                callback?(.success(result))
                            } catch {
                                print("Decode error:", error)
                                callback?(.failure(.generic(reason: "Could not decode data: \(error.localizedDescription)")))
                            }
                        }
                    }
                }
            dataTask.resume()
        }
        
        func get<Response>(_ endpoint: Types.Endpoint,
                           then callback: ((Result<Response, Types.Error>) -> ())? = nil)
        where Response: Decodable {
            let body: Types.Request.Empty? = nil
            fetch(endpoint, method: .get, body: body) { result in
                callback?(result)
            }
        }
        
        
        
    }
    
}
