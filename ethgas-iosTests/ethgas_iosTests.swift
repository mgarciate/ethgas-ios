//
//  ethgas_iosTests.swift
//  ethgas-iosTests
//
//  Created by mgarciate on 13/5/22.
//

import XCTest
import SnapshotTesting
import SwiftUI

class ethgas_iosTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDefaultAppearance() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        let itemAlertview = ItemAlertView(alert: AlertGas(value: 80, direction: AlertGasDirection.down, type: .standard, frequency: .once))
        assertSnapshot(matching: itemAlertview, as: .image)
        
        let cardValueView = CardValueView(viewModel: CardValueViewModel(value: 30, color: .pink, title: Resources.Strings.Common.Speed.fastest.uppercased(), subtitle: Resources.Strings.Common.Speed.fastestSubtitle))
        assertSnapshot(matching: cardValueView, as: .image)
    }
}

extension SwiftUI.View {
    func toVC() -> UIViewController {
        let vc = UIHostingController(rootView: self)
        vc.view.frame = UIScreen.main.bounds
        return vc
    }
}
