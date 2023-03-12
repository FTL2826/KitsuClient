//
//  DetailViewModelProtocol.swift
//  KitsuClient
//
//  Created by Александр Харин on /103/23.
//

import Foundation

protocol DetailViewModelProtocol {
    
    var pictureData: Dynamic<Data> { get }
    var titleLabel: String { get }
    var averageRatingLabel: String? { get }
    var startDateLabel: String { get }
    var endDateLabel: String { get }
    var statusLabel: String { get }
    var ageRatingGuideLabel: String { get }
    var synopsisLabel: String { get }
    var parts: String { get }
    var partsLabel: String { get }
    var partsLenght: String { get }
    var partsLenghtLabel: String { get }
    
    func loadPosterImage() -> URLSessionDataTask?
    
    func getRating(_ str: String?) -> String
}
