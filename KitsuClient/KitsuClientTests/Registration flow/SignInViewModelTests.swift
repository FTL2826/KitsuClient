//
//  SignInViewModelTests.swift
//  KitsuClientTests
//
//  Created by Александр Харин on /143/23.
//

import XCTest
@testable import KitsuClient

final class SignInViewModelTests: XCTestCase {

    var sut: SignInViewModel!
    let user = User(login: "login", email: "email", password: "password")
    
    override func setUpWithError() throws {
        let passwordVer = PasswordVerificationMock()
        passwordVer.users = [user]
        
        sut = SignInViewModel(passwordVerification: passwordVer)
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testValidateCredentialsTesxt() {
        // Given
        var email: String? = nil
        var password: String? = nil
        // When
        sut.validateTextFields(email: email, password: password)
        // Then
        XCTAssertEqual(sut.signInButtonValidation.value, false)
        
        // Given
        email = "email"
        password = "password"
        // When
        sut.validateTextFields(email: email, password: password)
        // Then
        XCTAssertEqual(sut.signInButtonValidation.value, true)
        
        // Given
        email = ""
        // When
        sut.validateTextFields(email: email, password: password)
        // Then
        XCTAssertEqual(sut.signInButtonValidation.value, false)
    }
    
    func testDidSignInPressed() {
        // Given
        // When
        sut.didSignInPressed(email: user.email, password: user.password)
        // Then
        XCTAssertEqual(sut.loginStatusLabelHidden.value, true)
        
        // Given
        // When
        sut.didSignInPressed(email: user.email, password: "pasword")
        // Then
        XCTAssertEqual(sut.loginStatusLabelHidden.value, false)
    }
    

}
