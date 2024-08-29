//
//  MainViewModel.swift
//  ethgas-ios
//
//  Created by mgarciate on 08/07/2021.
//

import FirebaseAuth
import WidgetKit
import SwiftUI

final class MainViewModel: MainViewModelProtocol {
    @Published var currentData: CurrentData = CurrentData.defaultData
    @Published var isSignedIn = false
    @Published var isMigrationAlertPresented = false
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    private var signInHandler: SignInWithAppleCoordinator?
    private let firebaseService: FirebaseService = FirebaseServiceImpl()
    
    init() {
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            guard let _ = user else {
                self?.checkMigrationFrom140(false)
                self?.isSignedIn = true
                return
            }
            self?.isSignedIn = false
            self?.saveToken()
            self?.fetchData()
            self?.checkMigrationFrom140(true)
        }
    }
    
    private func checkMigrationFrom140(_ migration: Bool) {
        // Show migration alert for already signed users and version = 1.5.0
        let migrationAlert = UserDefaults.standard.bool(forKey: "migration_alert_150")
        guard !migrationAlert else { return }
        guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
              appVersion == "1.5.0" else { return }
        guard migration else {
            saveMigrationFrom140()
            return
        }
        guard !isSignedIn else { return }
        saveMigrationFrom140()
        isMigrationAlertPresented = true
    }
    
    private func saveMigrationFrom140() {
        UserDefaults.standard.set(true, forKey: "migration_alert_150")
        UserDefaults.standard.synchronize()
    }
    
    private func saveToken() {
        guard let fcmToken = UserDefaults.standard.string(forKey: "firebase_token") else {
            #if DEBUG
            print("*** NO TOKEN")
            #endif
            return
        }
        self.firebaseService.saveToken(fcmToken: fcmToken)
    }
    
    private func fetchData() {
        firebaseService.currentData { result in
            switch result {
            case .success(let currentData):
                #if DEBUG
                print("*** CURRENT DATA \(currentData)")
                #endif
                self.currentData = currentData
                WidgetCenter.shared.reloadAllTimelines()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func signInWithAppleButtonTapped() {
        signInHandler = SignInWithAppleCoordinator(window: window)
        signInHandler?.signIn { (user) in
            #if DEBUG
            print("User signed in \(user.uid)")
            #endif
            self.presentationMode.wrappedValue.dismiss() // (3)
        }
    }
    
    func signOut() {
        try? Auth.auth().signOut()
    }
}
