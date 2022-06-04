//
//  AlertsViewModelProtocol.swift
//  ethgas-ios
//
//  Created by mgarciate on 4/6/22.
//

import Foundation

protocol AlertsViewModelProtocol: ObservableObject {
    var typeSelected: Int { get set }
    var value: String { get set }
    var frequency: AlertGasFrequency { get set }
    var showingFrequencySelection: Bool { get set }
    var alertsData: AlertsGas.Data { get set }
    
    func fetchAlerts()
    func removeAlert(_ alert: AlertGas)
    func saveAlert(currentData: CurrentData)
    func removeCurrentAlertsObserver()
    func currentDirection(currentData: CurrentData) -> AlertGasDirection
    func currentGasType() -> AlertGasType
}
