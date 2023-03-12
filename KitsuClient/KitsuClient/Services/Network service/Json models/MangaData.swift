//
//  MangaData.swift
//  KitsuClient
//
//  Created by Александр Харин on /83/23.
//

import Foundation

struct MangaData: Decodable {
    let id: String
    let type: String
    let attributes: MangaAttributes
}
