//
//  MangaPageViewModelTests.swift
//  KitsuClientTests
//
//  Created by Александр Харин on /84/23.
//

import XCTest
import Combine
@testable import KitsuClient

final class MangaPageViewModelTests: XCTestCase {

    private var sut: MangaPageViewModel!
    private var apiClient = APIClientMock()
    
    private var input: PassthroughSubject<MangaPageViewModel.Input, Never>!
    private var subscriptions = Set<AnyCancellable>()
    
    
    override func setUpWithError() throws {
        sut = MangaPageViewModel(apiClient: apiClient)
        input = PassthroughSubject<MangaPageViewModel.Input, Never>()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testTransform() {
        // Given
        let output = sut.transform(input: input.eraseToAnyPublisher())
        var outputFlow: [MangaPageViewModel.Output] = []
        var expectedOutputFlow: [MangaPageViewModel.Output] = []
        
        let expectation = expectation(description: "check output")
        output
            .sink { outputFlow.append($0) }
            .store(in: &subscriptions)
        
        // When
        apiClient.mangaTrendResult = .failure(.generic(reason: "test fail"))
        input.send(.viewDidLoad)
        expectedOutputFlow.append(.loadTrending(isLoading: true))
        // Then
        XCTAssert(apiClient.fetchWasCalled == 1, "Api was called first time")
        expectedOutputFlow.append(.fetchDidFail(error: .generic(reason: "test fail")))
        
        // When
        apiClient.mangaTrendResult = .success(API.Types.Response.TrendingMangaSearch(data: []))
        input.send(.viewDidLoad)
        // Then
        XCTAssert(apiClient.fetchWasCalled == 2, "Second api call")
        expectedOutputFlow.append(.loadTrending(isLoading: true))
        expectedOutputFlow.append(.loadTrending(isLoading: false))
        expectedOutputFlow.append(.fetchTrendigDidSucceed(info: []))
        apiClient.mangaTrendResult = nil
        
        // When
        apiClient.mangaAlltimeResult = .failure(.generic(reason: "test fail"))
        input.send(.paginationRequest(nextPageLink: ""))
        expectedOutputFlow.append(.loadNextPage(isLoading: true))
        // Then
        XCTAssert(apiClient.fetchWasCalled == 3, "Api was called first time")
        expectedOutputFlow.append(.fetchDidFail(error: .generic(reason: "test fail")))
        
        // When
        apiClient.mangaAlltimeResult = .success(API.Types.Response.MangaSearch(data: [], meta: Meta(count: 0), links: Links(first: "", next: "", last: "")))
        input.send(.paginationRequest(nextPageLink: ""))
        // Then
        XCTAssert(apiClient.fetchWasCalled == 4, "Second api call")
        expectedOutputFlow.append(.loadNextPage(isLoading: true))
        expectedOutputFlow.append(.loadNextPage(isLoading: false))
        expectedOutputFlow.append(.fetchNextPageDidSucceed(info: [], nextPageLink: ""))
        apiClient.mangaAlltimeResult = nil
        expectation.fulfill()
        
//        print(">>>> outputFlow: ", outputFlow)
//        print(">>>> expectedOutputFlow: ", expectedOutputFlow)
        XCTAssertTrue(outputFlow.count == expectedOutputFlow.count, ">>>> comparison: true")
        waitForExpectations(timeout: 10)

    }

}
