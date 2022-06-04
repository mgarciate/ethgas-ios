//
//  HotViewModel.swift
//  ethgas-ios
//
//  Created by mgarciate on 13/08/2021.
//

import FirebaseAuth
import FirebaseDatabase
import Combine

final class HotViewModel: HotViewModelProtocol {
    let ref = Database.database().reference()
    @Published var hotEntries = [IndexPath: HotEntry?]()
    @Published var typeSelected = 1
    
    private var weeklyEntries = [GraphEntry]()
    
    init() {
        #if DEBUG
        print("init")
        #endif
        fetchData()
    }
    
    deinit {
        #if DEBUG
        print("deinit")
        #endif
        removeObserver()
    }
    
    func removeObserver() {
        ref.child("gasprice/graph").removeAllObservers()
    }
    
    func fetchData() {
        guard let _ = Auth.auth().currentUser else { return }
        ref.child("gasprice/graph").observe(.value) { snapshot in
            #if DEBUG
            print("*** fetchData")
            #endif
            var dailyEntries = [GraphEntry]()
            for child in snapshot.childSnapshot(forPath: "daily").children {
                guard let value = (child as? DataSnapshot)?.value as? NSDictionary,
                      let timestamp = value["timestamp"] as? Int,
                      let ethusd = value["ethusd"] as? Double,
                      let fastest = value["fastest"] as? Int,
                      let fast = value["fast"] as? Int,
                      let average = value["average"] as? Int else {
                    return
                }
                dailyEntries.append(GraphEntry(timestamp: timestamp, ethusd: ethusd, fastest: fastest, fast: fast, average: average))
            }
            self.weeklyEntries = snapshot.childSnapshot(forPath: "weekly").children.map { (child) -> GraphEntry in
                guard let value = (child as? DataSnapshot)?.value as? NSDictionary,
                      let timestamp = value["timestamp"] as? Int,
                      let ethusd = value["ethusd"] as? Double,
                      let fastest = value["fastest"] as? Int,
                      let fast = value["fast"] as? Int,
                      let average = value["average"] as? Int else {
                    return GraphEntry(timestamp: 0, ethusd: 0, fastest: 0, fast: 0, average: 0)
                }
                return GraphEntry(timestamp: timestamp, ethusd: ethusd, fastest: fastest, fast: fast, average: average)
            }
            self.formatWeeklyEntries()
        }
    }
    
    private func formatWeeklyEntries() {
        var aux = [IndexPath: HotEntry?]()
        let values: [Int] = weeklyEntries.map {
            switch typeSelected {
            case 0:
                return $0.fastest
            case 1:
                return $0.fast
            default:
                return $0.average
            }
        }
        let valueMin = values.min() ?? 0
        let valueMax = values.max() ?? Int.max
        weeklyEntries.forEach { entry in
            if let day = entry.dayDifference, day < 7, day >= 0, let hour = entry.hour, hour < 24, hour >= 0 {
                let value: Int
                switch typeSelected {
                case 0:
                    value = entry.fastest
                case 1:
                    value = entry.fast
                default:
                    value = entry.average
                }
                aux[IndexPath(row: hour, section: day)] = HotEntry(entry: entry, value: value, alpha: (Double(entry.fast - valueMin) / Double(valueMax - valueMin)))
            }
        }
        print(aux)
        hotEntries = aux
        #if DEBUG
        print("*** \(hotEntries.count)")
        #endif
    }
    
    func valueSelected(_ value: Int) {
        formatWeeklyEntries()
    }
}
