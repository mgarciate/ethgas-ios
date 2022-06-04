//
//  CurrentData.swift
//  ethgas-ios
//
//  Created by mgarciate on 17/01/2021.
//

import Foundation

struct CurrentData {
    let id: Int
    let timestamp: Int
    let ethusd: Double
    let blockNum: Int
    let fastest: Int
    let fast: Int
    let average: Int
    let averageMax24h: Int
    let averageMin24h: Int
    let fastMax24h: Int
    let fastMin24h: Int
    let fastestMax24h: Int
    let fastestMin24h: Int
}

extension CurrentData {
    static var dummyData: CurrentData {
        return CurrentData(id: 1654337100, timestamp: 1654337100, ethusd: 1775.72, blockNum: 14902669, fastest: 48, fast: 37, average: 26, averageMax24h: 27, averageMin24h: 25, fastMax24h: 38, fastMin24h: 36, fastestMax24h: 49, fastestMin24h: 47)
    }
    
    var dateString: String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
        return dateFormatter.string(from: date)
    }
    
    var date: Date {
        return Date(timeIntervalSince1970: TimeInterval(timestamp))
    }
}
