//
//  ChartsViewModel.swift
//  ethgas-ios
//
//  Created by mgarciate on 5/6/22.
//

import Foundation

final class ChartsViewModel: ChartsViewModelProtocol {
    @Published var dailyEntries: [GraphEntry]
    @Published var weeklyEntries: [GraphEntry]
    private let firebaseService: FirebaseService
    
    init() {
        dailyEntries = [GraphEntry]()
        weeklyEntries = [GraphEntry]()
        firebaseService = FirebaseServiceImpl()
    }
    
    func fetchGraphs() {
        firebaseService.graphs { result in
            switch result {
            case.success(let graphs):
                self.dailyEntries = graphs.daily.reversed()
                self.weeklyEntries = graphs.weekly.reversed()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
