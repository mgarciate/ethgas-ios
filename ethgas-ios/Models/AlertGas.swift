//
//  AlertGas.swift
//  ethgas-ios
//
//  Created by mgarciate on 16/01/2021.
//

import Foundation

enum AlertGasDirection: String {
    case up, down
}

enum AlertGasType: String {
    case standard, fast, fastest
    var localized : String {
        switch self {
        case .fastest :
            return Resources.Strings.Common.Speed.fastest
        case .fast :
            return Resources.Strings.Common.Speed.fast
        case .standard :
            return Resources.Strings.Common.Speed.standard
        }
    }
}

struct AlertGas: Identifiable {
    let id: String
    let value: Int
    let direction: AlertGasDirection
    let type: AlertGasType
    
    init(value: Int, direction: AlertGasDirection, type: AlertGasType) {
        self.id = UUID().uuidString
        self.value = value
        self.direction = direction
        self.type = type
    }
    
    init(id: String, value: Int, direction: AlertGasDirection, type: AlertGasType) {
        self.id = id
        self.value = value
        self.direction = direction
        self.type = type
    }
}

struct AlertsGas {
    var alerts: [AlertGas]
}

extension AlertsGas {
    struct Data {
        var alerts: [AlertGas] = []
    }
    
    var data: Data {
        return Data(alerts: alerts)
    }
    
    mutating func update(from data: Data) {
        alerts = data.alerts
    }
}
