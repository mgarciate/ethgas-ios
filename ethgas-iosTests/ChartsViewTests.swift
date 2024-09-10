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
        // .image(drawHierarchyInKeyWindow: true, size: CGSize(width: 375, height: 812))
        // Workaround to keep the tests working with Swift Charts
        // See at https://github.com/pointfreeco/swift-snapshot-testing/discussions/784
        assertSnapshot(of: viewController, as: .image(drawHierarchyInKeyWindow: true, size: CGSize(width: 375, height: 812)))
        assertSnapshot(of: viewController, as: .image(drawHierarchyInKeyWindow: true, size: CGSize(width: 375, height: 812), traits: traitDarkMode))
    }
    
    func testChartsViewLargeScreen() throws {
        // .image(drawHierarchyInKeyWindow: true, size: CGSize(width: 414, height: 896))
        // Workaround to keep the tests working with Swift Charts
        // See at https://github.com/pointfreeco/swift-snapshot-testing/discussions/784
        assertSnapshot(of: viewController, as: .image(drawHierarchyInKeyWindow: true, size: CGSize(width: 414, height: 896)))
        assertSnapshot(of: viewController, as: .image(drawHierarchyInKeyWindow: true, size: CGSize(width: 414, height: 896), traits: traitDarkMode))
    }
}
