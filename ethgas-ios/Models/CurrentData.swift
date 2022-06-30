//
//  CurrentData.swift
//  ethgas-ios
//
//  Created by mgarciate on 17/01/2021.
//

import Foundation

struct CurrentData: Codable {
    let id: String = UUID().uuidString
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
    
    enum CodingKeys: String, CodingKey {
        case id
        case timestamp = "uid"
        case ethusd, blockNum, fastest, fast, average, averageMax24h, averageMin24h, fastMax24h, fastMin24h, fastestMax24h, fastestMin24h
    }
}

extension CurrentData {
    static var defaultData: CurrentData {
        return CurrentData(timestamp: 0, ethusd: 0.0, blockNum: 0, fastest: 0, fast: 0, average: 0, averageMax24h: 0, averageMin24h: 0, fastMax24h: 0, fastMin24h: 0, fastestMax24h: 0, fastestMin24h: 0)
    }
    
    static var dummyData: CurrentData {
        return CurrentData(timestamp: 1654337100, ethusd: 1775.72, blockNum: 14902669, fastest: 48, fast: 37, average: 26, averageMax24h: 27, averageMin24h: 25, fastMax24h: 38, fastMin24h: 36, fastestMax24h: 49, fastestMin24h: 47)
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
