//
//  FeesViewTests.swift
//  ethgas-iosTests
//
//  Created by mgarciate on 4/6/22.
//

import XCTest
import SnapshotTesting

class FeesViewTests: XCTestCase {
    var viewController: UIViewController!

    override func setUpWithError() throws {
        viewController = FeesView(currentData: .constant(CurrentData.dummyData), actionSheet: .constant(.fees)).toVC()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFeesViewRegularScreen() throws {
        assertSnapshot(matching: viewController, as: .image(on: .iPhoneX))
        assertSnapshot(matching: viewController, as: .image(on: .iPhoneX, traits: traitDarkMode))
    }
    
    func testFeesViewLargeScreen() throws {
        assertSnapshot(matching: viewController, as: .image(on: .iPhoneXsMax))
        assertSnapshot(matching: viewController, as: .image(on: .iPhoneXsMax, traits: traitDarkMode))
    }
}
