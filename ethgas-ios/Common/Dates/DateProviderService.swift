//
//  DateProviderService.swift
//  ethgas-ios
//
//  Created by mgarciate on 5/6/22.
//

import Foundation

protocol DateProviderService {
    var today: Date { get }
    var timeZone: TimeZone { get }
    var locale: Locale { get }
}
