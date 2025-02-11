//
//  KeychainManager.swift
//  Popcorn-iOS
//
//  Created by 김성훈 on 1/15/25.
//

import Foundation

protocol KeychainManagerProtocol {
    func fetchItem(with query: [String: Any]) -> Data?
    func addItem(with attributes: [String: Any]) -> OSStatus
    func updateItem(with query: [String: Any], as attributes: [String: Any]) -> OSStatus
    func deleteItem(with query: [String: Any]) -> OSStatus
    func loadSignupData() -> SignUpRequestDTO?

    func saveIdToken(provider: String, idToken: IdToken) -> Bool
    func getIdToken(provider: String) -> String?
    func deleteIdToken(provider: String)
}

final class KeychainManager: KeychainManagerProtocol {
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

    // MARK: - Add Item
    @discardableResult
    func addItem(with attributes: [String: Any]) -> OSStatus {
        let status = SecItemAdd(attributes as CFDictionary, nil)
        if status != errSecSuccess {
            print("키체인 Add Item 실패, 상태 코드: \(status)")
        }
        return status
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

    // MARK: - Load SignUp Data
    func loadSignupData() -> SignUpRequestDTO? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "signupData",
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        guard let data = fetchItem(with: query) else {
            print("키체인에서 데이터를 불러올 수 없습니다.")
            return nil
        }

        do {
            let signupData = try JSONDecoder().decode(SignUpRequestDTO.self, from: data)
            print("키체인 Load SignUp Data 성공: \(signupData)")
            return signupData
        } catch {
            print("키체인 Load SignUp Data 디코딩 실패: \(error)")
            return nil
        }
    }
}

// MARK: - IdToken
extension KeychainManager {
    func saveIdToken(provider: String, idToken: IdToken) -> Bool {
        let tokenData = Data(idToken.idToken.utf8)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: provider,
            kSecAttrAccount as String: "id_token",
            kSecValueData as String: tokenData
        ]

        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        if status == errSecSuccess {
            return true
        } else {
            print("\(provider) idToken 저장 실패: 상태 코드 \(status)")
            return false
        }
    }

    func getIdToken(provider: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: provider,
            kSecAttrAccount as String: "id_token",
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        guard let data = fetchItem(with: query) else {
            print("\(provider) idToken 불러오기 실패")
            return nil
        }

        guard let idToken = String(data: data, encoding: .utf8) else {
            print("\(provider) idToken 디코딩 실패")
            return nil
        }

        return idToken
    }

    func deleteIdToken(provider: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: provider,
            kSecAttrAccount as String: "id_token"
        ]

        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess {
            print("\(provider) idToken 삭제 실패: 상태 코드 \(status)")
        }
    }
}
