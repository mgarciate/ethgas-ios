//
//  MainWatchOSViewModel.swift
//  ethgas-watchos WatchKit Extension
//
//  Created by mgarciate on 28/4/22.
//

import FirebaseDatabase

final class MainWatchOSViewModel: ObservableObject {
    @Published var currentData: CurrentData = CurrentData.dummyData
    @Published var isLoading = false
    let ref = Database.database().reference()
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        isLoading = true
        ref.child("gasprice/widget/current/values").observeSingleEvent(of: .value) { snapshot in
            self.isLoading = false
            // Get user value
            guard let value = snapshot.value as? NSDictionary,
                  let id = value["uid"] as? Int,
                  let ethusd = value["ethusd"] as? Double,
                  let blockNum = value["blockNum"] as? Int,
                  let fastest = value["fastest"] as? Int,
                  let fast = value["fast"] as? Int,
                  let average = value["average"] as? Int,
                  let averageMax24h = value["averageMax24h"] as? Int,
                  let averageMin24h = value["averageMin24h"] as? Int,
                  let fastMax24h = value["fastMax24h"] as? Int,
                  let fastMin24h = value["fastMin24h"] as? Int,
                  let fastestMax24h = value["fastestMax24h"] as? Int,
                  let fastestMin24h = value["fastestMin24h"] as? Int else {
                return
            }
            self.currentData = CurrentData(id: id, timestamp: id, ethusd: ethusd, blockNum: blockNum,fastest: fastest, fast: fast, average: average, averageMax24h: averageMax24h, averageMin24h: averageMin24h, fastMax24h: fastMax24h, fastMin24h: fastMin24h, fastestMax24h: fastestMax24h, fastestMin24h: fastestMin24h)
        }
    }
}
