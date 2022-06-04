//
//  MockHotViewModel.swift
//  ethgas-ios
//
//  Created by mgarciate on 13/5/22.
//

import Foundation
import Combine

final class MockHotViewModel: HotViewModelProtocol {
    @Published var hotEntries: [IndexPath : HotEntry?] = HotEntry.dummyData
    @Published var typeSelected: Int = 1
    
    func removeObserver() {}
    
    func fetchData() {}
    
    func valueSelected(_ value: Int) {}
}

extension HotEntry {
    static var dummyData: [IndexPath: HotEntry?] {
        var entries = [IndexPath: HotEntry?]()
        for section in 0...6 {
            for item in 0...23 {
                entries[IndexPath(item: item, section: section)] = HotEntry(entry: GraphEntry(timestamp: 1652043600, ethusd: 2548.0, fastest: 20, fast: 19, average: 18), value: 19, alpha: 0.7)
            }
        }
        return entries
    }
}
