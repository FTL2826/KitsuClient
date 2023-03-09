//
//  Attributes.swift
//  KitsuClient
//
//  Created by Александр Харин on /73/23.
//

import Foundation

struct Attributes: Decodable {
    let canonicalTitle: String
    let startDate: String
    let averageRating: String
    let favoritesCount: Int
    let posterImage: PosterImage
}
