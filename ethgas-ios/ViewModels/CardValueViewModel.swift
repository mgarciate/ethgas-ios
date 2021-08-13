//
//  CardValueViewModel.swift
//  ethgas-ios
//
//  Created by mgarciate on 13/08/2021.
//

import SwiftUI

final class CardValueViewModel: ObservableObject {
    @Published var value: Int
    let color: Color
    let title: String
    let subtitle: String
    
    init(value: Int, color: Color, title: String, subtitle: String) {
        self.value = value
        self.color = color
        self.title = title
        self.subtitle = subtitle
    }
}
