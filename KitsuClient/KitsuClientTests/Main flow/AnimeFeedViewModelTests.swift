//
//  AnimeFeedViewModelTests.swift
//  KitsuClientTests
//
//  Created by Александр Харин on /143/23.
//

import XCTest
@testable import KitsuClient

final class AnimeFeedViewModelTests: XCTestCase {

    var sut: AnimeFeedViewModel!
    fileprivate let mockData = MockData()
    let api = APIClientMock<API.Types.Request, API.Types.Response>()
    
    override func setUpWithError() throws {
        
        sut = AnimeFeedViewModel(apiClient: api)
        
        sut.alltimeDataSource = mockData.data
        sut.trendingDataSource = mockData.data
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testNumbersOfRowsInSection() {
        // Given
        var segment: Segments = .trending
        // When
        var result = sut.numbersOfRowsInSection(section: 1, segment: .trending)
        // Then
        XCTAssertEqual(result, 0)
        
        // Given
        sut.trendingCount.value = 24
        // When
        result = sut.numbersOfRowsInSection(section: 0, segment: segment)
        // Then
        XCTAssertEqual(result, 24)
        
        // Given
        segment = .alltime
        sut.alltimeCount.value = 19
        // When
        result = sut.numbersOfRowsInSection(section: 0, segment: segment)
        // Then
        XCTAssertEqual(result, 19)
    }
    
    func testGetAnimeTitle() {
        // Given
        var index = 1
        var segment: Segments = .alltime
        // When
        var result = sut.getAnimeTitle(index: index, segment: segment)
        // Then
        XCTAssertEqual(result?.id, mockData.data[1].id)
        
        // Given
        index = 0
        segment = .trending
        // When
        result = sut.getAnimeTitle(index: index, segment: segment)
        // Then
        XCTAssertEqual(result?.id, mockData.data[0].id)
        
        // Given
        index = 2
        // When
        result = sut.getAnimeTitle(index: index, segment: segment)
        // Then
        XCTAssertTrue(result == nil)
        // Given
        index = 10
        segment = .alltime
        // When
        result = sut.getAnimeTitle(index: index, segment: segment)
        // Then
        XCTAssertTrue(result == nil)
        
    }
    
    func testFetchTrendingData() {
        // Given
        sut.isTrendingLoading.value = true
        // When
        var result = sut.isTrendingLoading.value
        sut.fetchTrendingData()
        // Then
        XCTAssertEqual(result, true)
        
        // Given
        sut.isTrendingLoading.value = false
        // When
        sut.fetchTrendingData()
        result = sut.isTrendingLoading.value
        // Then
        XCTAssertEqual(result, false)
        XCTAssertEqual(api.fetchWasCalled, 1)
        
        // Given
        let expectation = self.expectation(description: "Expectation in " + #function)
        sut.isTrendingLoading.value = false
        api.callbackStub = false
        // When
        sut.fetchTrendingData()
        result = sut.isTrendingLoading.value
        expectation.fulfill()
        // Then
        waitForExpectations(timeout: 3) { _ in
            XCTAssertEqual(result, false)
            XCTAssertEqual(self.api.fetchWasCalled, 2)
        }
    }

}


fileprivate struct MockData {
    var data: [TitleInfo] =
    [
        TitleInfo(id: "0", type: "manga", canonicalTitle: "title", startDate: nil, endDate: nil, favouritesCount: 23, averageRating: nil, ageRatingGuide: nil, status: "status", synopsis: "synopsis", posterImageTinyURL: nil, posterImageSmallURL: nil, posterImageOriginalURL: "url", chapterCount: nil, volumeCount: nil, episodesCount: nil, episodeLenght: nil),
        TitleInfo(id: "1", type: "manga", canonicalTitle: "title", startDate: nil, endDate: nil, favouritesCount: 23, averageRating: nil, ageRatingGuide: nil, status: "status", synopsis: "synopsis", posterImageTinyURL: nil, posterImageSmallURL: nil, posterImageOriginalURL: "url", chapterCount: nil, volumeCount: nil, episodesCount: nil, episodeLenght: nil),
    ]
}
