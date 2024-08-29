//
//  HotViewTests.swift
//  ethgas-iosTests
//
//  Created by mgarciate on 13/5/22.
//

import XCTest
import SnapshotTesting

class HotViewTests: XCTestCase {
    var viewController: UIViewController!

    override func setUpWithError() throws {
        viewController = HotView<MockHotViewModel>(actionSheet: .constant(.hot), viewModel: MockHotViewModel()).toVC()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testHotViewRegularScreen() throws {
        assertSnapshot(of: viewController, as: .image(on: .iPhoneX))
        assertSnapshot(of: viewController, as: .image(on: .iPhoneX, traits: traitDarkMode))
    }
    
    func testHotViewLargeScreen() throws {
        assertSnapshot(of: viewController, as: .image(on: .iPhoneXsMax))
        assertSnapshot(of: viewController, as: .image(on: .iPhoneXsMax, traits: traitDarkMode))
    }
}
