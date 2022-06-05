//
//  MockDateProvider.swift
//  ethgas-ios
//
//  Created by mgarciate on 5/6/22.
//

import Foundation

final class MockDateProvider: DateProviderService {
    var today: Date = Date(timeIntervalSince1970: 1654443814)
    var timeZone: TimeZone = TimeZone(identifier: "GMT")!
    var locale: Locale = Locale(identifier: "en-US")
}
