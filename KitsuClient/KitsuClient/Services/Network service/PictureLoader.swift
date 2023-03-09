//
//  PictureLoader.swift
//  KitsuClient
//
//  Created by Александр Харин on /93/23.
//

import Foundation


protocol PictureLoaderProtocol {
    func loadPicture(_ url: URL, then callback: ((Result<Data, API.Types.Error>) -> ())?) -> URLSessionDataTask
}

class PictureLoader: PictureLoaderProtocol {
    
    static let shared = PictureLoader()
    var session: URLSession
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = URLCache(memoryCapacity: 1024 * 1024 * 50, diskCapacity: 1024 * 1024 * 125)
        configuration.httpMaximumConnectionsPerHost = 7
        self.session = URLSession(configuration: configuration)
        
        print("Documents directory:", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])
    }
    
    func loadPicture(_ url: URL, then callback: ((Result<Data, API.Types.Error>) -> ())? = nil) -> URLSessionDataTask {
        let dataTask = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Image download error:", error)
                callback?(.failure(.generic(reason: "Error in response from poster picture url: \(error.localizedDescription)")))
            } else {
                if let data = data {
                    callback?(.success(data))
                }
            }
        }
        dataTask.resume()
        return dataTask
    }
}
