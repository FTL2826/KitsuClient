//
//  BaseTableViewCellViewModelTests.swift
//  KitsuClientTests
//
//  Created by Александр Харин on /123/23.
//

import XCTest
@testable import KitsuClient

final class BaseTableViewCellViewModelTests: XCTestCase {
    
    var sut: BaseTableViewCellViewModelProtocol!
    
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

    override func setUpWithError() throws {
        sut = BaseTableViewCellViewModel(
            titleInfo: testTitleInfo,
            pictureLoader: PictureLoaderMock())
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testGetData() {
        // Given
        var dateStr = testTitleInfo.startDate
        // When
        var result = sut.getDate(dateStr)
        // Then
        XCTAssertEqual(result, "06-12-1997")
        
        dateStr = nil
        result = sut.getDate(dateStr)
        XCTAssertEqual(result, "")
        
        dateStr = "1999-20-33"
        result = sut.getDate(dateStr)
        XCTAssertEqual(result, "")
        
        dateStr = "abrakadabra"
        result = sut.getDate(dateStr)
        XCTAssertEqual(result, "")
    }
    
    func testGetRating() {
        // Given
        var inputStr: String? = nil
        // When
        var result = sut.getRating(inputStr)
        // Then
        XCTAssertEqual(result, "no rating yet")
        
        inputStr = "90"
        result = sut.getRating(inputStr)
        XCTAssertEqual(result, "90 / 100")
    }
    
    func testGetPosterURL() {
        // Given
        let urlString = testTitleInfo.posterImageTinyURL ?? testTitleInfo.posterImageOriginalURL
        // When
        let result = sut.getPosterURL()
        // Then
        XCTAssertEqual(result, URL(string: urlString))
    }

}
