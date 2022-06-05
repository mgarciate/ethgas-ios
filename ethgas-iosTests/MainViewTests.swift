//
//  MainViewTests.swift
//  ethgas-iosTests
//
//  Created by mgarciate on 4/6/22.
//

import XCTest
import SnapshotTesting

class MainViewTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMainUnsigned() throws {
        let viewController = MainView<MockMainViewModel, MockAlertsViewModel, MockHotViewModel, MockChartsViewModel>(viewModel: MockMainViewModel(isSignedIn: true), alertsViewModel: MockAlertsViewModel(), hotViewModel: MockHotViewModel(), chartsViewModel: MockChartsViewModel()).toVC()
        assertSnapshot(matching: viewController, as: .image(on: .iPhoneX))
    }
    
    func testMainSigned() throws {
        let viewController = MainView<MockMainViewModel, MockAlertsViewModel, MockHotViewModel, MockChartsViewModel>(viewModel: MockMainViewModel(isSignedIn: false), alertsViewModel: MockAlertsViewModel(), hotViewModel: MockHotViewModel(), chartsViewModel: MockChartsViewModel()).toVC()
        assertSnapshot(matching: viewController, as: .image(on: .iPhoneX))
    }
}
