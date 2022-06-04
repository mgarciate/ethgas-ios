//
//  MockAlertsView.swift
//  ethgas-ios
//
//  Created by mgarciate on 4/6/22.
//

import Foundation

final class MockAlertsViewModel: AlertsViewModelProtocol {
    @Published var typeSelected: Int = 1
    @Published var value: String = "39"
    @Published var frequency: AlertGasFrequency = .daily
    @Published var showingFrequencySelection: Bool = false
    @Published var alertsData: AlertsGas.Data = AlertsGas.Data(alerts: [])
    
    func fetchAlerts() {
        alertsData = AlertsGas.Data.dummyData
    }
    
    func removeAlert(_ alert: AlertGas) {}
    
    func saveAlert(currentData: CurrentData) {}
    
    func removeCurrentAlertsObserver() {}
    
    func currentDirection(currentData: CurrentData) -> AlertGasDirection { return .up }
    
    func currentGasType() -> AlertGasType { return .fast }
}

extension AlertsGas.Data {
    static var dummyData: AlertsGas.Data {
        return AlertsGas.Data(alerts: [
            AlertGas(value: 49, direction: .up, type: .fastest, frequency: .once),
            AlertGas(value: 35, direction: .down, type: .fast, frequency: .daily),
            AlertGas(value: 10, direction: AlertGasDirection.down, type: .standard, frequency: .always),
        ])
    }
}
