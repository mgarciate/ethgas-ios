//
//  AlertsView.swift
//  ethgas-ios
//
//  Created by mgarciate on 16/01/2021.
//

import SwiftUI

struct AlertsView: View {
    @Binding var currentData: CurrentData
    @Binding var actionSheet: MainActionSheet?

    @State var alertsData: AlertsGas.Data
    @State private var typeSelected = 1
    @State private var value = ""
    @State private var frequency: AlertGasFrequency = .once
    @State private var showingFrequencySelection = false
    
    private let firebaseService: FirebaseService = FirebaseServiceImpl()
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 15)
            ZStack {
                HStack(spacing: 10) {
                    Text("\(currentData.fastest)")
                        .font(.title2)
                        .foregroundColor(.pink)
                        .opacity(typeSelected != 0 ? 0.4 : 1)
                    Rectangle()
                        .foregroundColor(.gray)
                        .frame(width: 1)
                    Text("\(currentData.fast)")
                        .font(.title2)
                        .foregroundColor(.blue)
                        .opacity(typeSelected != 1 ? 0.4 : 1)
                    Rectangle()
                        .foregroundColor(.gray)
                        .frame(width: 1)
                    Text("\(currentData.average)")
                        .font(.title2)
                        .foregroundColor(.green)
                        .opacity(typeSelected != 2 ? 0.4 : 1)
                }
                HStack {
                    Spacer()
                    Button(action: {
                        actionSheet = nil
                    }) {
                        Image(systemName: "multiply")
                            .resizable()
                            .scaledToFit()
                            .padding(5)
                            .foregroundColor(.white)
                            .background(Color.black)
                            .cornerRadius(15)
                        
                    }
                    .padding(.horizontal)
                    .frame(height: 30)
                }
            }
            .frame(height: 40)
            VStack {
                Picker(selection: $typeSelected, label: Text(Resources.Strings.Alerts.gasType)) {
                    Text(AlertGasType.fastest.localized.uppercased()).tag(0)
                    Text(AlertGasType.fast.localized.uppercased()).tag(1)
                    Text(AlertGasType.standard.localized.uppercased()).tag(2)
                }
                .padding(.top, -10)
                .padding(.bottom, -5)
                .pickerStyle(SegmentedPickerStyle())
                
                HStack {
                    Spacer()
//                    Text("Equivalent: $")
//                        .foregroundColor(.gray)
                }
                
                ZStack {
                    HStack {
                        Spacer()
                            .frame(width: 5)
                        Image(systemName: currentDirection() == .up ? "arrow.up" : "arrow.down")
                            .foregroundColor(currentDirection() == .up ? .green : .red)
                        Spacer()
                    }
                    TextField(Resources.Strings.Alerts.inputPlaceholder, text: $value)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.yellow)
                        .keyboardType(.numberPad)
                }
                .frame(height: 44)
                .border(Color.yellow, width: 1)
                
                Spacer()
                    .frame(height: 10)
                
                HStack {
                    Button(action: {
                        guard let gasValue = Int(value) else { return }
                        self.firebaseService.saveAlert(AlertGas(value: gasValue, direction: currentDirection(), type: currentGasType(), frequency: frequency)) { result in
                            switch result {
                            case .success:
                                //                            withAnimation {
                                //                                alertsData.alerts.append(alert)
                                //                            }
                                value = ""
                            case .failure: break
                            }
                        }
                    }) {
                        Text(Resources.Strings.Alerts.create.uppercased())
                            .frame(minWidth: 0, maxWidth: .infinity)
                    }
                    .disabled(value.isEmpty ||
                                alertsData.alerts.contains(where: { $0.type == currentGasType() && $0.value == Int(value) ?? -1 }) ||
                                Int(value) ?? 0 <= 0 ||
                                alertsData.alerts.count >= 20)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 44, maxHeight: 44)
                    .background(Color.yellow)
                    .foregroundColor(.black)
                    
                    Button(action: {
                        showingFrequencySelection = true
                    }) {
                        Text(frequency.localized)
                            .foregroundColor(Color("Black"))
                    }
                    .frame(minWidth: 0, maxWidth: 120, minHeight: 44, maxHeight: 44)
                }
            }
            .padding()
            .padding(.bottom, -10)
            
            Rectangle()
                .frame(height: 10)
                .foregroundColor(Color.black.opacity(0.1))
            
            List {
                ForEach(alertsData.alerts) { alert in
                    ItemAlertView(alert: alert)
                }
                .onDelete { indices in
                    let alertGas = alertsData.alerts[indices.first ?? 0]
                    self.firebaseService.removeAlert(alertGas) { _ in
//                        alertsData.alerts.remove(atOffsets: indices)
                    }
                }
            }
            
            Spacer()
        }
        .sheet(isPresented: $showingFrequencySelection) {
            FrequencySelectionView(frequency: $frequency)
        }
        .onAppear() {
            listAlerts()
        }
        .onDisappear() {
            firebaseService.removeCurrentAlertsObserver()
        }
    }
    
    func currentDirection() -> AlertGasDirection {
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
    
    func listAlerts() {
        self.firebaseService.currentAlerts { result in
            switch result {
            case .success(let alertsGas):
                self.alertsData = AlertsGas.Data(alerts: alertsGas.alerts)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

struct AlertsView_Previews: PreviewProvider {
    static var previews: some View {
        AlertsView(currentData: .constant(CurrentData.dummyData), actionSheet: .constant(.alerts), alertsData: AlertsGas.Data(alerts: [AlertGas(value: 80, direction: AlertGasDirection.down, type: .standard, frequency: .once)]))
    }
}
