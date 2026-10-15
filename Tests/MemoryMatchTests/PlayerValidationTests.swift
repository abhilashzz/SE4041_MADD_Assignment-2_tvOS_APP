//
//  PlayerValidationTests.swift
//  MemoryMatchTests
//
//  Created for SE4041 - MADD Assignment 2 Part B (tvOS)
//  Student: Abhilash K A T W (IT22081698)
//

import XCTest
@testable import MemoryMatch

final class PlayerValidationTests: XCTestCase {
    
    func testValidNameValidationAndTrimming() {
        let result = PlayerProfile.validateName("  Maya  ")
        switch result {
        case .success(let trimmed):
            XCTAssertEqual(trimmed, "Maya")
        case .failure:
            XCTFail("Should succeed for valid name with surrounding whitespace")
        }
    }
    
    func testRejectEmptyOrWhitespaceOnlyNames() {
        let emptyResult = PlayerProfile.validateName("")
        XCTAssertEqual(emptyResult, .failure(.emptyName))
        
        let whitespaceResult = PlayerProfile.validateName("    \t\n  ")
        XCTAssertEqual(whitespaceResult, .failure(.emptyName))
    }
    
    func testRejectNamesLongerThanTwentyFourCharacters() {
        let longName = String(repeating: "A", count: 25)
        let result = PlayerProfile.validateName(longName)
        XCTAssertEqual(result, .failure(.nameTooLong))
    }
    
    func testInitialsGeneration() {
        let singleName = PlayerProfile(name: "Maya")
        XCTAssertEqual(singleName.initials, "M")
        
        let twoPartName = PlayerProfile(name: "Leo Silva")
        XCTAssertEqual(twoPartName.initials, "LS")
        
        let threePartName = PlayerProfile(name: "Abhilash K A")
        XCTAssertEqual(threePartName.initials, "AK")
        
        let spacedName = PlayerProfile(name: "  Sarah   Connor  ")
        XCTAssertEqual(spacedName.initials, "SC")
    }
    
    func testPreventDuplicatePlayerProfileInBothSlots() {
        let profile = PlayerProfile(name: "Maya")
        let appState = AppState()
        let vm = PlayerSetupViewModel(appState: appState)
        
        // Try assigning Maya to both slot 1 and slot 2
        vm.selectPlayer(profile, for: .playerOne)
        vm.selectPlayer(profile, for: .playerTwo)
        
        XCTAssertNotEqual(vm.playerOne.id, vm.playerTwo.id, "Player 1 and Player 2 cannot share the same profile UUID")
        XCTAssertNotNil(vm.addPlayerErrorMessage)
    }
}
