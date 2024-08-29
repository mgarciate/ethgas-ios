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
    
    func testItemAlertView() throws {
        let itemAlertview = ItemAlertView(alert: AlertGas(value: 80, direction: AlertGasDirection.down, type: .standard, frequency: .once))
        assertSnapshot(of: itemAlertview, as: .image(layout: .fixed(width: ViewImageConfig.iPhoneX.size!.width, height: 50)))
    }

    func testAlertsViewRegularScreen() throws {
        assertSnapshot(of: viewController, as: .image(on: .iPhoneX))
        assertSnapshot(of: viewController, as: .image(on: .iPhoneX, traits: traitDarkMode))
    }
    
    func testAlertViewLargeScreen() throws {
        assertSnapshot(of: viewController, as: .image(on: .iPhoneXsMax))
        assertSnapshot(of: viewController, as: .image(on: .iPhoneXsMax, traits: traitDarkMode))
    }
}
