//
//  PictureLoaderMock.swift
//  KitsuClientTests
//
//  Created by Александр Харин on /143/23.
//

import Foundation
@testable import KitsuClient

class PictureLoaderMock: PictureLoaderProtocol {
    
    private(set) var wasCalled = 0
    var callbackStub: Result<Data, KitsuClient.API.Types.Error>?
    
    func loadPicture(_ url: URL, then callback: ((Result<Data, KitsuClient.API.Types.Error>) -> ())?) -> URLSessionDataTask {
        
        wasCalled += 1
        callbackStub.map { callback?($0) }
        
        return URLSessionDataTask()
    }
    
    
}
