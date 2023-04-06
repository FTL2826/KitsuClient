//
//  DetailViewModel.swift
//  KitsuClient
//
//  Created by Александр Харин on /103/23.
//

import Foundation
import Combine

fileprivate enum ReverseDate {
    static func getDate(_ str: String?) -> String? {
        guard let str = str else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: str)
        if let date = date {
            dateFormatter.dateFormat = "dd-MM-yyyy"
            return dateFormatter.string(from: date)
        }
        return nil
    }
}

class DetailViewModel: DetailViewModelProtocol {
    
    var pictureLoader: PictureLoaderProtocol
    
    var pictureData = PassthroughSubject<Data, Never>()
    var subscriptions = Set<AnyCancellable>()
    
    var type: String
    var titleLabel: String
    var averageRatingLabel: String?
    var startDateLabel: String
    var endDateLabel: String
    var statusLabel: String
    var ageRatingGuideLabel: String
    var synopsisLabel: String
    let parts: String
    var partsLabel: String
    let partsLenght: String
    var partsLenghtLabel: String
    
    var posterImageURL: String
    
    init(
        pictureLoader: PictureLoaderProtocol,
        titleInfo: TitleInfo
    ) {
        self.pictureLoader = pictureLoader
        
        self.type = titleInfo.type
        self.titleLabel = titleInfo.canonicalTitle
        self.posterImageURL = titleInfo.posterImageSmallURL ?? titleInfo.posterImageOriginalURL
        self.averageRatingLabel = titleInfo.averageRating
        self.startDateLabel = ReverseDate.getDate(titleInfo.startDate) ?? "Not started yet"
        self.endDateLabel = ReverseDate.getDate(titleInfo.endDate) ?? "Not finished"
        self.statusLabel = titleInfo.status
        self.ageRatingGuideLabel = titleInfo.ageRatingGuide ?? "No info"
        self.synopsisLabel = "Synopsis: " + titleInfo.synopsis
        
        if type == "manga" {
            self.parts = "Volumes: "
            if let volumeCount = titleInfo.volumeCount {
                self.partsLabel = String(volumeCount)
            } else {
                self.partsLabel = "??"
            }
            self.partsLenght = "Chapters: "
            if let chaptersCount = titleInfo.chapterCount {
                self.partsLenghtLabel = String(chaptersCount)
            } else {
                self.partsLenghtLabel = "??"
            }
        } else if type == "anime" {
            self.parts = "Episodes: "
            if let episodeCount = titleInfo.episodesCount {
                self.partsLabel = String(episodeCount)
            } else {
                self.partsLabel = "??"
            }
            self.partsLenght = "Episode's lenght: "
            if let episodeLenght = titleInfo.episodeLenght {
                self.partsLenghtLabel = String(episodeLenght) + " min"
            } else {
                self.partsLenghtLabel = "??"
            }
        } else {
            self.parts = ""
            self.partsLabel = ""
            self.partsLenght = ""
            self.partsLenghtLabel = ""
        }
        
        pictureLoader.loadPicture(getPosterURL())
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    break
                }
            } receiveValue: {[unowned self] data in
                self.pictureData.send(data)
            }.store(in: &subscriptions)

    }
    
    private func getPosterURL() -> URL? {
        URL(string: posterImageURL)
    }
    
    func getRating(_ str: String?) -> String {
        if let str = str {
            return str + " / 100"
        }
        return "No rating 🫣"
    }
    
}
