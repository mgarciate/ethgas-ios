//
//  MainActionSheet.swift
//  ethgas-ios
//
//  Created by mgarciate on 13/5/22.
//

enum MainActionSheet: Identifiable {
    case alerts, graphs, hot, fees
    
    var id: Int {
        hashValue
    }
}
