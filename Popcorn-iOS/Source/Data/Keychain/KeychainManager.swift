//
//  KeychainManager.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 1/15/25.
//

import Foundation

final class KeychainManager {
    @discardableResult
    func fetchItem(with query: [String: Any]) -> AnyObject? {
        var item: CFTypeRef?
        _ = SecItemCopyMatching(query as CFDictionary, &item)
        return item
    }

    @discardableResult
    func addItem(with attributes: [String: Any]) -> OSStatus {
        let status = SecItemAdd(attributes as CFDictionary, nil)
        return status
    }

    @discardableResult
    func updateItem(with query: [String: Any], as attributes: [String: Any]) -> OSStatus {
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        return status
    }

    @discardableResult
    func deleteItem(with query: [String: Any]) -> OSStatus {
        let status = SecItemDelete(query as CFDictionary)
        return status
    }
}
