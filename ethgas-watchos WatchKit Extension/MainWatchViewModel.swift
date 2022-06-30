//
//  MainWatchViewModel.swift
//  ethgas-watchos WatchKit Extension
//
//  Created by mgarciate on 28/4/22.
//

import Foundation

final class MainWatchViewModel: ObservableObject {
    @Published var currentData: CurrentData = CurrentData.defaultData
    @Published var isLoading: Bool = false
    
    func loadData() {
        guard !isLoading else { return }
        #if DEBUG
        print("*** loadData")
        #endif
        isLoading = true
        Task {
            do {
                let currentData = try await NetworkService<CurrentData>().get(endpoint: "gasprice/current")
                DispatchQueue.main.async { [weak self] in
                    self?.currentData = currentData
                }
            } catch {
                print("Error", error)
            }
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
}
