//
//  ImageFetchManagerRepositoryProtocol.swift
//  Popcorn-iOS
//
//  Created by 제민우 on 2/5/25.
//

import Foundation

protocol ImageFetchManagerRepositoryProtocol {
    func fetchImage(url: URL, completion: @escaping (Result<Data, ImageFetchError>) -> Void)
}
