//
//  KeychainManager.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 1/15/25.
//

import Foundation

protocol KeychainManagerProtocol {
    func addItem(with attributes: [String: Any]) -> OSStatus
    func fetchItem(with query: [String: Any]) -> Data?
    func updateItem(with query: [String: Any], as attributes: [String: Any]) -> OSStatus
    func deleteItem(with query: [String: Any]) -> OSStatus
}

final class KeychainManager: KeychainManagerProtocol {
    // MARK: - Add Item
    @discardableResult
    func addItem(with attributes: [String: Any]) -> OSStatus {
        let status = SecItemAdd(attributes as CFDictionary, nil)
        if status != errSecSuccess {
            print("키체인 Add Item 실패, 상태 코드: \(status)")
        }
        return status
    }

    // MARK: - Fetch Item
    @discardableResult
    func fetchItem(with query: [String: Any]) -> Data? {
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        if status == errSecSuccess, let data = item as? Data {
            return data
        } else {
            print("키체인 Fetch Item 실패, 상태 코드: \(status)")
            return nil
        }
    }

    // MARK: - Update Item
    @discardableResult
    func updateItem(with query: [String: Any], as attributes: [String: Any]) -> OSStatus {
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        if status != errSecSuccess {
            print("키체인 Update Item 실패, 상태 코드: \(status)")
        }
        return status
    }

    // MARK: - Delete Item
    @discardableResult
    func deleteItem(with query: [String: Any]) -> OSStatus {
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess {
            print("키체인 Delete Item 실패, 상태 코드: \(status)")
        }
        return status
    }
}

// MARK: - IdToken
extension KeychainManager {
    @discardableResult
    func saveIdToken(_ idToken: String) -> OSStatus {
        let data = Data(idToken.utf8)

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "idToken"
        ]

        let attributes: [String: Any] = [
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]

        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        if status == errSecItemNotFound {
            let addQuery = query.merging(attributes) { _, new in new }
            return SecItemAdd(addQuery as CFDictionary, nil)
        }
        return status
    }

    func fetchIdToken() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "idToken",
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        guard let data = fetchItem(with: query) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    // MARK: - Delete IdToken
    @discardableResult
    func deleteIdToken() -> OSStatus {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "idToken"
        ]

        return deleteItem(with: query)
    }
}
