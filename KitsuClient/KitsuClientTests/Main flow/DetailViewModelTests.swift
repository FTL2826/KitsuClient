//
//  DetailViewModelTests.swift
//  KitsuClientTests
//
//  Created by Александр Харин on /143/23.
//

import XCTest
@testable import KitsuClient

final class DetailViewModelTests: XCTestCase {

    var sut: DetailViewModel!
    
    var testTitleInfo = TitleInfo(
        id: "1",
        type: "manga",
        canonicalTitle: "title",
        startDate: nil, //"1997-12-06",
        endDate: nil, //"2004-08-23",
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
    
//    func testLoadPosterImage() {
//        // Given
//        let str = "mocked picture"
//        let data = str.data(using: .utf8)!
//        sut.posterImageURL = ""
//        // When
//        sut.loadPosterImage()
//        // Then
//        XCTAssertEqual(sut.pictureData.value, Data())
//
//        // Given
//        sut.posterImageURL = "failuremock"
//        // When
//        sut.loadPosterImage()
//        // Then
//        XCTAssertEqual(sut.pictureData.value, Data())
//
//        // Given
//        sut.posterImageURL = testTitleInfo.posterImageOriginalURL
//        // When
//        sut.loadPosterImage()
//        // Then
//        XCTAssertEqual(sut.pictureData.value, data)
//    }
    func testLoadPosterImage() {
        // Given
        sut.posterImageURL = ""
        // When
        sut.loadPosterImage()
        // Then
        XCTAssertEqual(pictureLoader.wasCalled, 0)
        
        // Given
        sut.posterImageURL = testTitleInfo.posterImageOriginalURL
        pictureLoader.callbackStub = .failure(.internal(reason: "picture loader mock error"))
        // When
        sut.loadPosterImage()
        // Then
        XCTAssertEqual(pictureLoader.wasCalled, 1)
        
        // Given
        let str = "mocked picture"
        let data = str.data(using: .utf8)!
        pictureLoader.callbackStub = .success(data)
        // When
        sut.loadPosterImage()
        // Then
        XCTAssertEqual(pictureLoader.wasCalled, 2)
        XCTAssertEqual(sut.pictureData.value, data)
    }

}
