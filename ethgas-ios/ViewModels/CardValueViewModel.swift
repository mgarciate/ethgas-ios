//
//  CardValueViewModel.swift
//  ethgas-ios
//
//  Created by mgarciate on 13/08/2021.
//

import SwiftUI

final class CardValueViewModel: ObservableObject {
    @Published var value: String
    let color: Color
    let title: String
    let subtitle: String
    
    init(value: Double, color: Color, title: String, subtitle: String) {
        self.value = value.gasValueString
        self.color = color
        self.title = title
        self.subtitle = subtitle
    }
}
