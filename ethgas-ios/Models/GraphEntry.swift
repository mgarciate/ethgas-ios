//
//  GraphEntry.swift
//  ethgas-ios
//
//  Created by mgarciate on 07/02/2021.
//

import Foundation

struct GraphEntry {
    let timestamp: Int
    let ethusd: Double
    let fastest: Double
    let fast: Double
    let average: Double
}

extension GraphEntry {
    static var dummyData: GraphEntry {
        return GraphEntry(timestamp: 0, ethusd: 0.0, fastest: 0.0, fast: 0.0, average: 0.0)
    }
    
    var dateString: String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
        return dateFormatter.string(from: date)
    }
    
    var dayDifference: Int? {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: date)
        let date2 = calendar.startOfDay(for: Date())
        return calendar.dateComponents([.day], from: date1, to: date2).day
    }
    
    var hour: Int? {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        return Calendar.current.dateComponents([.hour], from: date).hour
    }
    
    var weekdayAbbreviated: String? {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale(identifier: "en-US")
        dateFormatter.dateFormat = "EEE"
        return dateFormatter.string(from: date)
    }
}
