//
//  ChartsViewModelProtocol.swift
//  ethgas-ios
//
//  Created by mgarciate on 5/6/22.
//

import Foundation

protocol ChartsViewModelProtocol: ObservableObject {
    var dailyEntries: [GraphEntry] { get set }
    var weeklyEntries: [GraphEntry] { get set }
    
    func fetchGraphs()
}
