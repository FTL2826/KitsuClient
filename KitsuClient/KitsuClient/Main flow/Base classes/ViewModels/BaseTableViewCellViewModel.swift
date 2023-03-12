//
//  BaseTableViewCellViewModel.swift
//  KitsuClient
//
//  Created by Александр Харин on /93/23.
//

import Foundation

class BaseTableViewCellViewModel: BaseTableViewCellViewModelProtocol {
    
    var pictureLoader: PictureLoaderProtocol
    
    var id: String
    var title: String
    var dateString: String?
    var likes: String
    var rating: String?
    var imageURL: String
    
    init(
        titleInfo: TitleInfo,
        pictureLoader: PictureLoaderProtocol
    ) {
        self.pictureLoader = pictureLoader
        
        self.id = titleInfo.id
        self.title = titleInfo.canonicalTitle
        self.dateString = titleInfo.startDate
        self.likes = "\(titleInfo.favouritesCount)"
        self.rating = titleInfo.averageRating
        self.imageURL = titleInfo.posterImageTinyURL ?? titleInfo.posterImageOriginalURL
    }
    
    func getDate(_ str: String?) -> String {
        var dateString = ""
        defer {
            if dateString.isEmpty {
                dateString = "not started"
            }
        }
        guard let str = str else { return dateString }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: str)
        if let date = date {
            dateFormatter.dateFormat = "dd-MM-yyyy"
            return dateFormatter.string(from: date)
        } else {
            return dateString
        }
    }
    
    func getRating(_ str: String?) -> String {
        if let str = str {
            return str + " / 100"
        } else {
            return "no rating yet"
        }
    }
    
    func getPosterURL() -> URL? {
        URL(string: imageURL)
    }
    
}
