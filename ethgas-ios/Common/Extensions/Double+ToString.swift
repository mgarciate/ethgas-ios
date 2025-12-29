//
//  Double+ToString.swift
//  ethgas-ios
//
//  Created by mgarciate on 26/8/24.
//

import Foundation

extension Double {
    
    var gasValueString: String {
        return Int(self) < 10 ? String(format: "%.2f", self) : "\(Int(self))"
    }
    
    var gasValueStringShort: String {
        return switch self {
        case ..<0.1:
            String(format: "%.2f", self)
        case 0.1..<10:
            String(format: "%.1f", self)
        default:
            "\(Int(self))"
        }
    }
}
