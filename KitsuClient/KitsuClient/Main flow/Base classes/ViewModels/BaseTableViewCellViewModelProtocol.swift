//
//  BaseTableViewCellViewModelProtocol.swift
//  KitsuClient
//
//  Created by Александр Харин on /103/23.
//

import Foundation

protocol BaseTableViewCellViewModelProtocol {
    
    var pictureLoader: PictureLoaderProtocol { get }
    
    var id: String { get }
    var title: String { get }
    var dateString: String? { get }
    var likes: String { get }
    var rating: String? { get }
    var imageURL: String { get }
    
    func getDate(_ str: String?) -> String
    func getRating(_ str: String?) -> String
    func getPosterURL() -> URL?
    
}
