//
//  FrequencySelectionViewTests.swift
//  ethgas-iosTests
//
//  Created by mgarciate on 13/5/22.
//

import XCTest
import SnapshotTesting

class FrequencySelectionViewTests: XCTestCase {
    var viewController: UIViewController!

    override func setUpWithError() throws {
        viewController = FrequencySelectionView(frequency: .constant(.once)).toVC()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFrequencySelectionViewRegularScreen() throws {
        assertSnapshot(of: viewController, as: .image(on: .iPhoneX))
        assertSnapshot(of: viewController, as: .image(on: .iPhoneX, traits: traitDarkMode))
    }
    
    func testFrequencySelectionViewLargeScreen() throws {
        assertSnapshot(of: viewController, as: .image(on: .iPhoneXsMax))
        assertSnapshot(of: viewController, as: .image(on: .iPhoneXsMax, traits: traitDarkMode))
    }
}
