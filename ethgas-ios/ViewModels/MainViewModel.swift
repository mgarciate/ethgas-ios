//
//  MainViewModel.swift
//  ethgas-ios
//
//  Created by mgarciate on 08/07/2021.
//

import FirebaseAuth
import WidgetKit

final class MainViewModel: ObservableObject {
    @Published var currentData: CurrentData = CurrentData.dummyData
    @Published var isSignedIn = false
    private let firebaseService: FirebaseService = FirebaseServiceImpl()
    
    init() {
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            guard let _ = user else {
                self?.isSignedIn = true
                return
            }
            self?.isSignedIn = false
            self?.saveToken()
            self?.fetchData()
        }
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
    
    func signOut() {
        try? Auth.auth().signOut()
    }
}
