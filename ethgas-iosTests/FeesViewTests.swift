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
    
    func testItemFeeView() throws {
        let view = ItemFeeView(data: ItemFee(title: "ETH Transfer", gasLimit: 21000, fastest: 100, fast: 50, average: 25, ethusd: 4000))
        assertSnapshot(matching: view, as: .image(layout: .fixed(width: 375, height: 100)))
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
