//
//  TitleInfo.swift
//  KitsuClient
//
//  Created by Александр Харин on /93/23.
//

struct TitleInfo: Hashable {
    let internalID: String //unique internal ID for UITableViewDiffableDataSource
    let id: String
    let type: String
    
    let canonicalTitle: String
    let startDate: String?
    let endDate: String?
    let favouritesCount: Int
    let averageRating: String?
    let ageRatingGuide: String?
    let status: String
    let synopsis: String
    
    let posterImageTinyURL: String?
    let posterImageSmallURL: String?
    let posterImageOriginalURL: String
    
    let chapterCount: Int?
    let volumeCount: Int?
    
    let episodesCount: Int?
    let episodeLenght: Int?
}
