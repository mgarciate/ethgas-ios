//
//  DateProvider.swift
//  ethgas-ios
//
//  Created by mgarciate on 5/6/22.
//

import Foundation

final class DateProvider: DateProviderService {
    var today: Date = Date()
    var timeZone: TimeZone = TimeZone.current
    var locale: Locale = Locale.current
}
