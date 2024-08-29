//
//  MainMiniViewTests.swift
//  ethgas-iosTests
//
//  Created by mgarciate on 2/7/22.
//

import XCTest
import SnapshotTesting

class MainMiniViewTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testMiniView() throws {
        let view = MainMiniView(currentData: .constant(CurrentData.dummyData))
        assertSnapshot(of: view, as: .image(layout: .fixed(width: 200.0, height: 200.0)))
        assertSnapshot(of: view, as: .image(layout: .fixed(width: 200.0, height: 200.0), traits: traitDarkMode))
    }
}
