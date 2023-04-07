//
//  AnimePageViewModelProtocol.swift
//  KitsuClient
//
//  Created by Александр Харин on /313/23.
//

import Foundation
import Combine

protocol AnimePageViewModelProtocol {
    func transform(input: AnyPublisher<AnimePageViewModel.Input, Never>) -> AnyPublisher<AnimePageViewModel.Output, Never>
}
