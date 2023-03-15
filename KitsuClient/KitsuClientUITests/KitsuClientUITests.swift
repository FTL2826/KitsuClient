//
//  KitsuClientUITests.swift
//  KitsuClientUITests
//
//  Created by Александр Харин on /123/23.
//

import XCTest

final class KitsuClientUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func signInAndLogoutTest() throws {
        let app = XCUIApplication()
        app.launch()
        
        let signInButton = app.buttons["Sign In"]
        XCTAssertTrue(signInButton.exists)
        XCTAssertTrue(!signInButton.isEnabled)
        
        let userEmailField = app.textFields["Email address"]
        XCTAssertTrue(userEmailField.exists)
        userEmailField.tap()
        let email = "admin@mail.com"
        userEmailField.typeText(email)
        
        let passwordField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordField.exists)
        passwordField.tap()
        passwordField.typeText("12345")
        app.buttons["Done"].tap()
        
        XCTAssertTrue(signInButton.isEnabled)
        signInButton.tap()
                
        let emailLabel = app.staticTexts[email]
        XCTAssertTrue(emailLabel.exists)
        
        let logoutButton = XCUIApplication().tables.cells.staticTexts["Log out"]
        XCTAssertTrue(logoutButton.exists)
        
        logoutButton.tap()
        
        XCTAssertTrue(signInButton.exists && userEmailField.exists && passwordField.exists)
        
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
