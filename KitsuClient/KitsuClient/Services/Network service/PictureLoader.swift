//
//  PictureLoader.swift
//  KitsuClient
//
//  Created by Александр Харин on /93/23.
//

import Foundation
import Combine

protocol PictureLoaderProtocol {
    func loadPicture(_ url: URL?) -> Future<Data, API.Types.Error>
}

class PictureLoader: PictureLoaderProtocol {
    
    static let shared = PictureLoader()
    var session: URLSession
    var subscriptions = Set<AnyCancellable>()
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = URLCache(memoryCapacity: 1024 * 1024 * 50, diskCapacity: 1024 * 1024 * 125)
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.httpMaximumConnectionsPerHost = 7
        self.session = URLSession(configuration: configuration)
        
        print("Documents directory:", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])
    }
    
    func loadPicture(_ url: URL?) -> Future<Data, API.Types.Error> {
        return Future<Data, API.Types.Error> {[unowned self] promise in
            guard let url = url else {
                promise(.failure(API.Types.Error.generic(reason: "error: URL is nil")))
                return }
            self.session.dataTaskPublisher(for: url)
                .tryMap { (data, response) in
                    guard let httpResponse = response as? HTTPURLResponse,
                          200...299 ~= httpResponse.statusCode
                    else {
                        throw API.Types.Error.generic(reason: "Wrong httpresponse status code in picture loader")
                    }
                    return data
                }
                .sink(receiveCompletion: { _ in},
                      receiveValue: { promise(.success($0)) } )
                .store(in: &self.subscriptions)
        }
    }
}
