//
//  Cancellable.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 1/23/25.
//

import Foundation

protocol Cancellable {
    func cancel()
}

extension URLSessionTask: Cancellable { }
