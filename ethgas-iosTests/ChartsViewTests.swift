//
//  ChartsViewTests.swift
//  ethgas-iosTests
//
//  Created by mgarciate on 5/6/22.
//

import XCTest
import SnapshotTesting

class ChartsViewTests: XCTestCase {
    var viewController: UIViewController!

    override func setUpWithError() throws {
        viewController = ChartsView(actionSheet: .constant(.graphs), viewModel: MockChartsViewModel()).toVC()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testChartsViewRegularScreen() throws {
        assertSnapshot(matching: viewController, as: .image(on: .iPhoneX))
        assertSnapshot(matching: viewController, as: .image(on: .iPhoneX, traits: traitDarkMode))
    }
    
    func testChartsViewLargeScreen() throws {
        assertSnapshot(matching: viewController, as: .image(on: .iPhoneXsMax))
        assertSnapshot(matching: viewController, as: .image(on: .iPhoneXsMax, traits: traitDarkMode))
    }
}
