//
//  MemoryMatchNavigationUITests.swift
//  MemoryMatchUITests
//
//  Created for SE4041 - MADD Assignment 2 Part B (tvOS)
//  Student: Abhilash K A T W (IT22081698)
//

import XCTest

final class MemoryMatchNavigationUITests: XCTestCase {
    
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
    
    func testHomeScreenLoadsWithBrandingAndModeControls() {
        // Verify MemoryMatch branding
        XCTAssertTrue(app.staticTexts["MemoryMatch"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.staticTexts["Find a pair. Share the fun."].exists)
        XCTAssertTrue(app.staticTexts["Two players. One remote."].exists)
        
        // Verify Mode and Difficulty buttons exist
        XCTAssertTrue(app.buttons["Classic"].exists || app.staticTexts["Classic"].exists)
        XCTAssertTrue(app.buttons["Learn"].exists || app.staticTexts["Learn"].exists)
        XCTAssertTrue(app.buttons["Start Game"].exists)
        XCTAssertTrue(app.buttons["Leaderboard"].exists)
    }
    
    func testNavigationHomeToPlayerSetupAndBack() {
        let startGameButton = app.buttons["Start Game"]
        XCTAssertTrue(startGameButton.waitForExistence(timeout: 4))
        startGameButton.tap()
        
        // Verifies Player Setup screen loaded
        XCTAssertTrue(app.staticTexts["Who's playing?"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.buttons["Start Round"].exists)
        
        // Tap Back to Home
        let backButton = app.buttons["Back"]
        XCTAssertTrue(backButton.exists)
        backButton.tap()
        
        // Verifies returned to Home screen
        XCTAssertTrue(app.staticTexts["Find a pair. Share the fun."].waitForExistence(timeout: 3))
    }
    
    func testNavigationHomeToLeaderboardAndBack() {
        let leaderboardButton = app.buttons["Leaderboard"]
        XCTAssertTrue(leaderboardButton.waitForExistence(timeout: 4))
        leaderboardButton.tap()
        
        // Verifies Local Leaderboard screen loaded
        XCTAssertTrue(app.staticTexts["Local Leaderboard"].waitForExistence(timeout: 3))
        
        // Tap Back
        let backButton = app.buttons["Back"]
        XCTAssertTrue(backButton.exists)
        backButton.tap()
        
        // Verifies returned to Home
        XCTAssertTrue(app.staticTexts["Find a pair. Share the fun."].waitForExistence(timeout: 3))
    }
    
    func testHowToPlayOverlayOpensAndDismisses() {
        let howToPlayButton = app.buttons["How to play"]
        XCTAssertTrue(howToPlayButton.waitForExistence(timeout: 4))
        howToPlayButton.tap()
        
        // Verifies overlay opened
        XCTAssertTrue(app.staticTexts["How to Play MemoryMatch"].waitForExistence(timeout: 3))
        
        // Dismiss
        let closeButton = app.buttons["Close"]
        if closeButton.exists {
            closeButton.tap()
        } else {
            let gotItButton = app.buttons["Got it, Let's Play!"]
            gotItButton.tap()
        }
        
        XCTAssertFalse(app.staticTexts["How to Play MemoryMatch"].exists)
    }
}
