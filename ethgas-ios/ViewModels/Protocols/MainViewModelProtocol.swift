//
//  MainViewModelProtocol.swift
//  ethgas-ios
//
//  Created by mgarciate on 4/6/22.
//

import Foundation
import SwiftUI

protocol MainViewModelProtocol: ObservableObject {
    var currentData: CurrentData { get set }
    var isSignedIn: Bool  { get set }
    var isMigrationAlertPresented: Bool { get set }
    
    func signInWithAppleButtonTapped()
    func signOut()
}


