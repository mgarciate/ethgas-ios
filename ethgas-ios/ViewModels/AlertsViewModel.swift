//
//  AlertsViewModel.swift
//  ethgas-ios
//
//  Created by mgarciate on 4/6/22.
//

import Foundation

final class AlertsViewModel: AlertsViewModelProtocol {
    @Published var typeSelected: Int
    @Published var value: String
    @Published var frequency: AlertGasFrequency
    @Published var showingFrequencySelection: Bool
    @Published var alertsData: AlertsGas.Data
    private let service: FirebaseService = FirebaseServiceImpl()
    
    init() {
        typeSelected = 1
        value = ""
        frequency = .once
        showingFrequencySelection = false
        alertsData = AlertsGas.Data(alerts: [])
    }
    
    func fetchAlerts() {
        service.currentAlerts { result in
            switch result {
            case .success(let alertsGas):
                self.alertsData = AlertsGas.Data(alerts: alertsGas.alerts)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func removeAlert(_ alert: AlertGas) {
        self.service.removeAlert(alert) { _ in
//                        alertsData.alerts.remove(atOffsets: indices)
        }
    }
    
    func saveAlert(currentData: CurrentData) {
        guard let gasValue = Int(value) else { return }
        service.saveAlert(AlertGas(value: gasValue, direction: currentDirection(currentData: currentData), type: currentGasType(), frequency: frequency)) { result in
            switch result {
            case .success:
                self.value = ""
            case .failure: break
            }
        }
    }
    
    func removeCurrentAlertsObserver() {
        service.removeCurrentAlertsObserver()
    }
    
    func currentDirection(currentData: CurrentData) -> AlertGasDirection {
        let currentValue: Int
        switch typeSelected {
        case 0:
            currentValue = currentData.fastest
        case 1:
            currentValue = currentData.fast
        default:
            currentValue = currentData.average
        }
        return (currentValue < Int(value) ?? 0) ? .up : .down
    }
    
    func currentGasType() -> AlertGasType {
        switch typeSelected {
        case 0:
            return .fastest
        case 1:
            return .fast
        default:
            return .standard
        }
    }
}
