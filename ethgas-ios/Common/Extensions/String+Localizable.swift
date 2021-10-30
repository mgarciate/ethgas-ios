//
//  String+Localizable.swift
//  ethgas-ios
//
//  Created by mgarciate on 13/08/2021.
//

import Foundation

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
