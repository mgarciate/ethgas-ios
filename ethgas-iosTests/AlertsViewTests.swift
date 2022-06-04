//
//  AlertsViewTests.swift
//  ethgas-iosTests
//
//  Created by mgarciate on 13/5/22.
//

import XCTest
import SnapshotTesting

class AlertsViewTests: XCTestCase {
    var viewController: UIViewController!

    override func setUpWithError() throws {
        let view = AlertsView(currentData: .constant(CurrentData.dummyData), actionSheet: .constant(.alerts), viewModel: MockAlertsViewModel())
        viewController = view.toVC()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAlertsViewRegularScreen() throws {
        assertSnapshot(matching: viewController, as: .image(on: .iPhoneX))
        assertSnapshot(matching: viewController, as: .image(on: .iPhoneX, traits: traitDarkMode))
    }
    
    func testAlertViewLargeScreen() throws {
        assertSnapshot(matching: viewController, as: .image(on: .iPhoneXsMax))
        assertSnapshot(matching: viewController, as: .image(on: .iPhoneXsMax, traits: traitDarkMode))
    }
}
