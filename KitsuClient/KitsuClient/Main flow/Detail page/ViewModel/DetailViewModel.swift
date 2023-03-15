//
//  DetailViewModel.swift
//  KitsuClient
//
//  Created by Александр Харин on /103/23.
//

import Foundation

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
    
    var type: String
    var pictureData = Dynamic(Data())
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
    
    func loadPosterImage() -> URLSessionDataTask? {
        guard let url = getPosterURL() else { return nil }
        return pictureLoader.loadPicture(url) { [weak self] (result: Result<Data, API.Types.Error>) in
            switch result {
            case .success(let success):
                self?.pictureData.value = success
            case .failure(let failure):
                print("Poster image loading error (for detail view):", failure.localizedDescription)
            }
        }
    }
}
