//
//  ImageFetchUseCaseProtocol.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 2/5/25.
//

import Foundation

protocol ImageFetchUseCaseProtocol {
    func fetchImage(url: URL, completion: @escaping (Result<Data, ImageFetchError>) -> Void)
}
