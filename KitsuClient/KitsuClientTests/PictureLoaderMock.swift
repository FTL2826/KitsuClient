//
//  PictureLoaderMock.swift
//  KitsuClientTests
//
//  Created by Александр Харин on /143/23.
//

import Foundation
import Combine
@testable import KitsuClient

class PictureLoaderMock: PictureLoaderProtocol {
    
    private(set) var wasCalled = 0
    var loadPictureResult: Future<Data, KitsuClient.API.Types.Error>?
    
    func loadPicture(_ url: URL?) -> Future<Data, KitsuClient.API.Types.Error> {
        wasCalled += 1
        if let result = loadPictureResult {
            return result
        } else {
            fatalError("Must not be nil for test")
        }
    }

}
