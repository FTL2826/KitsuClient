//
//  ForgotViewModelTests.swift
//  KitsuClientTests
//
//  Created by Александр Харин on /143/23.
//

import XCTest
@testable import KitsuClient

final class ForgotViewModelTests: XCTestCase {

    var sut: ForgotViewModel!
    let user = User(login: "login", email: "email", password: "password")
    
    override func setUpWithError() throws {
        let passVer = PasswordVerificationMock()
        passVer.users = [user]
        
        sut = ForgotViewModel(passwordVerification: passVer)
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testValidateTextFields() {
        // Given
        // When
        sut.validateTextFields(email: user.email)
        // Then
        XCTAssertEqual(sut.forgotPasswordButtonValidation.value, true)
        
        // Given
        // When
        sut.validateTextFields(email: "")
        // Then
        XCTAssertEqual(sut.forgotPasswordButtonValidation.value, false)
    }
    
    func testDidPressedResetPasswordButton() {
        // Given
        // When
        sut.didPressedResetPasswordButton(email: "user.email")
        // Then
        XCTAssertEqual(sut.textColor.value, .red)
        
        // Given
        // When
        sut.didPressedResetPasswordButton(email: user.email)
        // Then
        XCTAssertEqual(sut.textColor.value, .green)
    }

}
