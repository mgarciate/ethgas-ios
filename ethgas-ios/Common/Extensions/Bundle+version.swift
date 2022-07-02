//
//  Bundle+version.swift
//  ethgas-ios
//
//  Created by mgarciate on 2/7/22.
//

import Foundation

extension Bundle {
    
    func appVersion() -> String? {
        guard let dictionary = infoDictionary, let version = dictionary["CFBundleShortVersionString"] as? String, let build = dictionary["CFBundleVersion"] as? String else {
            return nil
        }
        return "v\(version) (\(build))"
    }
}
