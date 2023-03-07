//
//  AnimeFeedViewModel.swift
//  KitsuClient
//
//  Created by Александр Харин on /73/23.
//

import Foundation

class AnimeFeedViewModel: AnimeFeedViewModelProtocol {
    
    var apiClient: APIClientProtocol
    
    var isLoading = Dynamic(false)
    
    var dataSource: Dynamic<[AnimeTitle]> = Dynamic([])
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func numbersOfSections() -> Int {
        1
    }
    
    func rowsInSection(_ section: Int) -> Int {
        dataSource.value.count
    }
    
    func fetchData() {
        if isLoading.value == true {
            return
        }
        isLoading.value = true
        
        apiClient.get(.anime(offset: "0")) { [weak self] (result: Result<API.Types.Response.AnimeSearch, API.Types.Error>) in
            switch result {
            case .success(let success):
                self?.isLoading.value = false
                self?.mapResults(success)
            case .failure(let failure):
                self?.isLoading.value = false
                print("Error:", failure)
            }
        }
    }
    
    private func mapResults(_ results: API.Types.Response.AnimeSearch) {
        var localResults = [AnimeTitle]()
        
        for result in results.data {
            localResults.append(AnimeTitle(
                id: result.id,
                canonicalTitle: result.attributes.canonicalTitle))
        }
        
        self.dataSource.value = localResults
    }
    
    func getAnimeTitle(_ indexPath: IndexPath) -> String {
        let anime = dataSource.value[indexPath.row]
        return anime.canonicalTitle
    }
    
}
