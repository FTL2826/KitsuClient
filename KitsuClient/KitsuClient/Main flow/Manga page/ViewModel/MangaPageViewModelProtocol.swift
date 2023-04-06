//
//  MangaPageViewModelProtocol.swift
//  KitsuClient
//
//  Created by Александр Харин on /313/23.
//

import Foundation
import Combine

protocol MangaPageViewModelProtocol {
    func transform(input: AnyPublisher<MangaPageViewModel.Input, Never>) -> AnyPublisher<MangaPageViewModel.Output, Never>
}
