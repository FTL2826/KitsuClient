//
//  APITypes.swift
//  KitsuClient
//
//  Created by Александр Харин on /282/23.
//

import Foundation

extension API {
    
    enum Types {
        
        enum Response {
           
            struct AnimeSearch: Decodable {
                let data: [AnimeSearchData]
                let meta: Meta
                let links: Links
            }
            
        }
        
        enum Request {
            // here will be post request to api
            struct Empty: Encodable {}
        }
        
        enum Error: LocalizedError {
            case generic(reason: String)
            case `internal`(reason: String)
            
            var errorDescription: String? {
                switch self {
                case .generic(let reason):
                    return reason
                case .internal(let reason):
                    return "Internal error: \(reason)"
                }
            }
        }
        
        enum Endpoint {
            case anime(offset: String)
            case manga(offset: String)
            
            var url: URL {
                var components = URLComponents()
                components.host = "kitsu.io"
                components.scheme = "https"
                switch self {
                case .anime(let offset):
                    components.path = "/api/edge/anime"
                    components.queryItems = [
                        URLQueryItem(name: "page[limit]", value: "10"),
                        URLQueryItem(name: "page[offset]", value: offset),
                    ]
                case .manga(let offset):
                    components.path = "/api/edge/manga"
                    components.queryItems = [
                        URLQueryItem(name: "page[limit]", value: "10"),
                        URLQueryItem(name: "page[offset]", value: offset),
                    ]
                }
//                print("URL:", components.url!)
                return components.url!
            }
        }
        
        enum Method: String {
            case get
            case post
        }
        
    }
    
    
}
