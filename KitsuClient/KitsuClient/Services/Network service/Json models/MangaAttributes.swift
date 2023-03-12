//
//  MangaAttributes.swift
//  KitsuClient
//
//  Created by Александр Харин on /83/23.
//

import Foundation

struct MangaAttributes: Decodable {
    let canonicalTitle: String
    let startDate: String?
    let endDate: String?
    let averageRating: String?
    let favoritesCount: Int
    let posterImage: PosterImage
    let status: String
    let ageRatingGuide: String?
    let chapterCount: Int?
    let volumeCount: Int?
    let synopsis: String
}
