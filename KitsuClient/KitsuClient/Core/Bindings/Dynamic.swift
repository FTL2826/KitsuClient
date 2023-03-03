//
//  Dynamic.swift
//  KitsuClient
//
//  Created by Александр Харин on /282/23.
//

import Foundation

class Dynamic<T> {
    
    typealias Listener = (T) -> ()
    
    private var listener: Listener?
    
    func bind(listener: Listener?) {
        self.listener = listener
    }
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    
}
