//
//  APIClientProtocol.swift
//  KitsuClient
//
//  Created by Александр Харин on /282/23.
//

import Foundation

protocol APIClientProtocol: AnyObject {
    
    func fetch<Request, Response>(_ endpoint: API.Types.Endpoint,
                                  method: API.Types.Method,
                                  body: Request?,
                                  then callback: ((Result<Response, API.Types.Error>) -> ())?
    ) where Request: Encodable, Response: Decodable
    
    func get<Response>(_ endpoint: API.Types.Endpoint,
                       then callback: ((Result<Response, API.Types.Error>) -> ())?)
    where Response: Decodable
}
