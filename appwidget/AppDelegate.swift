//
//  AppDelegate.swift
//  appwidgetExtension
//
//  Created by mgarciate on 03/04/2021.
//

import Foundation
import UIKit
import Firebase

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
