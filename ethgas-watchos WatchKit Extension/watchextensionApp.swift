//
//  watchextensionApp.swift
//  ethgas-watchos WatchKit Extension
//
//  Created by mgarciate on 24/4/22.
//

import SwiftUI
import Firebase

@main
struct watchExtensionApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                MainView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
