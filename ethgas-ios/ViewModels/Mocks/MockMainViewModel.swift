//
//  MockMainViewModel.swift
//  ethgas-ios
//
//  Created by mgarciate on 4/6/22.
//

import Foundation
import SwiftUI

final class MockMainViewModel: MainViewModelProtocol {
    @Published var currentData: CurrentData = CurrentData.dummyData
    @Published var isSignedIn: Bool
    @Published var isMigrationAlertPresented: Bool = false
    
    init(isSignedIn: Bool) {
        self.isSignedIn = isSignedIn
    }

    func signInWithAppleButtonTapped() {
        isSignedIn = false
    }
    
    func signOut() {
        isSignedIn = true
    }
}
