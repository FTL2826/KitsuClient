//
//  SignUpViewModelTests.swift
//  KitsuClientTests
//
//  Created by Александр Харин on /143/23.
//

import XCTest
@testable import KitsuClient

final class SignUpViewModelTests: XCTestCase {

    var sut: SignUpViewModel!
    let uniqUser = User(login: "uniqLogin", email: "uniqEmail", password: "uniqPassword")
    
    override func setUpWithError() throws {
        let passVer = PasswordVerificationMock()
        passVer.users = [uniqUser]
        
        sut = SignUpViewModel(passwordVerification: passVer)
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testValidateTextFields() {
        // Given
        var login: String? = nil
        var email: String? = nil
        var password: String? = nil
        // When
        sut.validateTextFields(login: login, email: email, password: password)
        // Then
        XCTAssertEqual(sut.signUpButtonValidation.value, false)
        
        // Given
        login = ""
        email = ""
        password = ""
        // When
        sut.validateTextFields(login: login, email: email, password: password)
        // Then
        XCTAssertEqual(sut.signUpButtonValidation.value, false)
        
        // Given
        login = "l"
        email = "e"
        password = "p"
        // When
        sut.validateTextFields(login: login, email: email, password: password)
        // Then
        XCTAssertEqual(sut.signUpButtonValidation.value, true)
        
        // Given
        login = uniqUser.login
        email = uniqUser.email
        password = uniqUser.password
        // When
        sut.validateTextFields(login: login, email: email, password: password)
        // Then
        XCTAssertEqual(sut.uniqEmail.value, false)
    }
    
    func testDidPressedSignUpButton() {
        // Given
        var login: String? = nil
        var email: String? = nil
        var password: String? = nil
        // When
        sut.didPressedSignUpButton(login: login, email: email, password: password)
        var result = sut.passwordVerification?.users.count
        let count = result
        // Then
        XCTAssertEqual(result, count)
        
        // Given
        login = uniqUser.login
        email = uniqUser.email
        password = uniqUser.password
        // When
        sut.didPressedSignUpButton(login: login, email: email, password: password)
        result = sut.passwordVerification?.users.count
        // Then
        XCTAssertEqual(result, count)
        
        // Given
        login = "l"
        email = "e"
        password = "p"
        // When
        sut.didPressedSignUpButton(login: login, email: email, password: password)
        result = sut.passwordVerification?.users.count
        // Then
        XCTAssertEqual(result, count! + 1)
        
        // Given
        login = uniqUser.login
        email = "em"
        password = "pa"
        // When
        sut.didPressedSignUpButton(login: login, email: email, password: password)
        result = sut.passwordVerification?.users.count
        // Then
        XCTAssertEqual(result, count! + 2)
        
        // Given
        login = uniqUser.login
        email = "ema"
        password = uniqUser.password
        // When
        sut.didPressedSignUpButton(login: login, email: email, password: password)
        result = sut.passwordVerification?.users.count
        // Then
        XCTAssertEqual(result, count! + 3)
    }

}
