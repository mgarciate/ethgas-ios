//
//  ethgas_iosApp.swift
//  ethgas-ios
//
//  Created by mgarciate on 04/01/2021.
//

import SwiftUI

@main
struct ethgas_iosApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: MainViewModel(), alertsViewModel: AlertsViewModel(), hotViewModel: HotViewModel(), chartsViewModel: ChartsViewModel())
        }
    }
    
    init() {
        UIScrollView.appearance().keyboardDismissMode = .onDrag
    }
}
