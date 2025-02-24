//
//  DetailSceneUseCaseTests.swift
//  Popcorn-iOSTests
//
//  Created by 제민우 on 2/24/25.
//

import XCTest
@testable import Popcorn_iOS

final class DetailSceneUseCaseTests: XCTestCase {
    var repository: PopupDetailRepositoryProtocol!
    var useCase: PopupDetailUseCaseProtocol!

    override func setUp() {
        super.setUp()
        repository = DummyPopupDetailRepository()
        useCase = PopupDetailUseCase(repository: repository)
    }
    
    override func tearDown() {
        repository = nil
        useCase = nil
        super.tearDown()
    }
    
    func test_해시태그가_정상적으로_추출되는지() {
        // Given
        let popupInfo1 = PopupInformation(
            popupId: -1,
            popupImagesUrl: [""],
            popupTitle: "",
            startDate: Date(),
            endDate: Date(timeIntervalSince1970: 864000), // 1970-01-01 기준 +10일
            isUserPick: true,
            hashTags: [],
            address: "서울 강남구",
            organizationUrl: "",
            businesesHours: "",
            introduce: "",
            reservationUrl: ""
        )
        
        let popupInfo2 = PopupInformation(
            popupId: -1,
            popupImagesUrl: [""],
            popupTitle: "",
            startDate: Date(),
            endDate: Date(timeIntervalSince1970: 432000), // 1970-01-01 기준 +5일
            isUserPick: true,
            hashTags: [],
            address: "부산 남구",
            organizationUrl: "",
            businesesHours: "",
            introduce: "",
            reservationUrl: ""
        )
        
        let popupInfo3 = PopupInformation(
            popupId: -1,
            popupImagesUrl: [""],
            popupTitle: "",
            startDate: Date(),
            endDate: Date(timeIntervalSince1970: -432000), // 1970-01-01 기준 -5일
            isUserPick: true,
            hashTags: [],
            address: "부산 남구 대연동",
            organizationUrl: "",
            businesesHours: "",
            introduce: "",
            reservationUrl: ""
        )
        
        // When
        let tags1 = useCase.extractHashTag(from: popupInfo1)
        let tags2 = useCase.extractHashTag(from: popupInfo2)
        let tags3 = useCase.extractHashTag(from: popupInfo3)

        // Then
        XCTAssertEqual(tags1, ["서울 강남구", "10"])
        XCTAssertEqual(tags2, ["부산 남구", "5"])
        XCTAssertEqual(tags3, ["부산 남구 대연동", "-5"])
    }
}
