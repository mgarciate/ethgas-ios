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
        assertSnapshot(of: view, as: .image(layout: .fixed(width: ViewImageConfig.iPhoneX.size!.width, height: 100)))
    }

    func testFeesViewRegularScreen() throws {
        assertSnapshot(of: viewController, as: .image(on: .iPhoneX))
        assertSnapshot(of: viewController, as: .image(on: .iPhoneX, traits: traitDarkMode))
    }
    
    func testFeesViewLargeScreen() throws {
        assertSnapshot(of: viewController, as: .image(on: .iPhoneXsMax))
        assertSnapshot(of: viewController, as: .image(on: .iPhoneXsMax, traits: traitDarkMode))
    }
}
