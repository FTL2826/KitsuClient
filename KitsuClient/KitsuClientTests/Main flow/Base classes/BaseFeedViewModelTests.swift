//
//  BaseFeedViewModelTests.swift
//  KitsuClientTests
//
//  Created by Александр Харин on /123/23.
//

import XCTest
@testable import KitsuClient

final class BaseFeedViewModelTests: XCTestCase {
    
    var sut: BaseFeedViewModelProtocol!

    override func setUpWithError() throws {
        sut = BaseFeedViewModel()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testNumbersOfSections() {
        // Given
        var segment: Segments = .trending
        // When
        var result = sut.numbersOfSections(segment: segment)
        // Then
        XCTAssertEqual(result, 1)
        
        segment = .alltime
        result = sut.numbersOfSections(segment: segment)
        XCTAssertEqual(result, 1)
    }
    
    func testNumbersOfRowsInSection() {
        // Given
        var section = 0
        var segment: Segments = .alltime
        // When
        var result = sut.numbersOfRowsInSection(section: section, segment: segment)
        // Then
        XCTAssertEqual(result, 20)
        
        segment = .trending
        result = sut.numbersOfRowsInSection(section: section, segment: segment)
        XCTAssertEqual(result, 10)
        
        section = 1
        result = sut.numbersOfRowsInSection(section: section, segment: segment)
        XCTAssertEqual(result, 0)
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
        XCTAssertEqual(result, true)
        
        let expectation = self.expectation(description: "Expectation in " + #function)
        DispatchQueue.global().asyncAfter(deadline: .now() + 3.5) { expectation.fulfill()
        }
        waitForExpectations(timeout: 4) { _ in
            XCTAssertEqual(self.sut.isTrendingLoading.value, false)
        }
        
    }
    
    func testFetchAlltimeData() {
        // Given
        sut.isAlltimeLoading.value = true
        // When
        var result = sut.isAlltimeLoading.value
        sut.fetchAlltimeData()
        // Then
        XCTAssertEqual(result, true)
        
        // Given
        sut.isAlltimeLoading.value = false
        // When
        sut.fetchAlltimeData()
        result = sut.isAlltimeLoading.value
        // Then
        XCTAssertEqual(result, true)
        
        let expectation = self.expectation(description: "Expectation in " + #function)
        DispatchQueue.global().asyncAfter(deadline: .now() + 3.5) { expectation.fulfill()
        }
        waitForExpectations(timeout: 4) { _ in
            XCTAssertEqual(self.sut.isAlltimeLoading.value, false)
        }
        
    }

}
