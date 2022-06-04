//
//  ethgas_iosTests.swift
//  ethgas-iosTests
//
//  Created by mgarciate on 13/5/22.
//

import XCTest
import SnapshotTesting

class ethgas_iosTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCardValueViews() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        
        let valueViewModel = CardValueViewModel(value: 30, color: .pink, title: Resources.Strings.Common.Speed.fastest.uppercased(), subtitle: Resources.Strings.Common.Speed.fastestSubtitle)
        let cardValueView = CardValueView(viewModel: valueViewModel)
        assertSnapshot(matching: cardValueView, as: .image(layout: .fixed(width: ViewImageConfig.iPhoneX.size!.width, height: 100)))
        
        let cardValueSmallView = CardValueSmallView(viewModel: valueViewModel)
        assertSnapshot(matching: cardValueSmallView, as: .image(layout: .fixed(width: 100, height: 100)))
    }
    
    func testAppleSignInButton() throws {
        let button = SignInWithAppleButton()
        assertSnapshot(matching: button, as: .image)
    }
}
