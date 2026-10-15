//
//  GameBoardInteractionUITests.swift
//  MemoryMatchUITests
//
//  Created for SE4041 - MADD Assignment 2 Part B (tvOS)
//  Student: Abhilash K A T W (IT22081698)
//

import XCTest

final class GameBoardInteractionUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launch()
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    func testGameBoardStartsAndCardsHaveNonRevealingIdentifiers() {
        // Navigate Home -> Player Setup -> Game Board
        let startGameButton = app.buttons["Start Game"]
        XCTAssertTrue(startGameButton.waitForExistence(timeout: 4))
        startGameButton.tap()
        
        let startRoundButton = app.buttons["Start Round"]
        XCTAssertTrue(startRoundButton.waitForExistence(timeout: 4))
        startRoundButton.tap()
        
        // Verify Board header
        XCTAssertTrue(app.buttons["Pause"].waitForExistence(timeout: 4))
        
        // Cards must exist and have nonrevealing identifiers
        let card00 = app.buttons["card_r0_c0"]
        let card01 = app.buttons["card_r0_c1"]
        XCTAssertTrue(card00.exists, "Card at row 0, col 0 must exist with nonrevealing identifier")
        XCTAssertTrue(card01.exists, "Card at row 0, col 1 must exist with nonrevealing identifier")
        
        // Face-down card accessibility label must NOT expose hidden content
        let initialLabel = card00.label
        XCTAssertFalse(initialLabel.contains("Apple"), "Face down card must not reveal its item to VoiceOver")
        XCTAssertFalse(initialLabel.contains("Book"), "Face down card must not reveal its item to VoiceOver")
        XCTAssertTrue(initialLabel.contains("Hidden card"), "Face down card must state it is hidden")
    }
    
    func testPauseAndResumeOverlay() {
        // Navigate to board
        app.buttons["Start Game"].tap()
        app.buttons["Start Round"].tap()
        
        let pauseButton = app.buttons["Pause"]
        XCTAssertTrue(pauseButton.waitForExistence(timeout: 4))
        pauseButton.tap()
        
        // Verify Pause overlay
        XCTAssertTrue(app.staticTexts["Game Paused"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.buttons["Resume Game"].exists)
        XCTAssertTrue(app.buttons["Restart Round"].exists)
        XCTAssertTrue(app.buttons["Exit to Home"].exists)
        
        // Resume
        app.buttons["Resume Game"].tap()
        XCTAssertFalse(app.staticTexts["Game Paused"].exists)
    }
}
