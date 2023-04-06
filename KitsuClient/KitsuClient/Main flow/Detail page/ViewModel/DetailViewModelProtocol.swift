//
//  DetailViewModelProtocol.swift
//  KitsuClient
//
//  Created by Александр Харин on /103/23.
//

import Foundation
import Combine

protocol DetailViewModelProtocol {
    
    var pictureData: PassthroughSubject<Data, Never> { get }
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
    
    func getRating(_ str: String?) -> String
}
