//
//  DetailViewModelTests.swift
//  KitsuClientTests
//
//  Created by Александр Харин on /143/23.
//

import XCTest
import Combine
@testable import KitsuClient

final class DetailViewModelTests: XCTestCase {

    var sut: DetailViewModel!
    
    var testTitleInfo = TitleInfo(
        internalID: UUID().uuidString,
        id: "1",
        type: "manga",
        canonicalTitle: "title",
        startDate: "1997-12-06",
        endDate: "2004-08-23",
        favouritesCount: 14,
        averageRating: nil,
        ageRatingGuide: nil,
        status: "finished",
        synopsis: "synopsis",
        posterImageTinyURL: nil,
        posterImageSmallURL: nil,
        posterImageOriginalURL: "url",
        chapterCount: nil,
        volumeCount: nil,
        episodesCount: nil,
        episodeLenght: nil)
    
    let pictureLoader = PictureLoaderMock()
    
    
    override func setUpWithError() throws {
        pictureLoader.loadPictureResult = Future() { promise in
            promise(.failure(.generic(reason: "unit test")))
        }
        sut = DetailViewModel(pictureLoader: pictureLoader, titleInfo: testTitleInfo)
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testGetRating() {
        // Given
        var inputStr: String? = nil
        // When
        var result = sut.getRating(inputStr)
        // Then
        XCTAssertEqual(result, "No rating 🫣")
        
        inputStr = "90"
        result = sut.getRating(inputStr)
        XCTAssertEqual(result, "90 / 100")
    }
    
    func testPictureLoad() {
        // Given
//        pictureLoader.loadPictureResult = Future() { promise in
//            promise(.failure(.generic(reason: "unit test")))
//        }
        // When sut inited
        
        // Then
        XCTAssertEqual(pictureLoader.wasCalled, 1, "New call")
//        XCTAssert(output === pictureLoader.loadPictureResult!, "Return Future")
    }

}
