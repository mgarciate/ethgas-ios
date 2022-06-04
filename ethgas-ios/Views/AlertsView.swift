//
//  AlertsView.swift
//  ethgas-ios
//
//  Created by mgarciate on 16/01/2021.
//

import SwiftUI

struct AlertsView<ViewModel>: View where ViewModel: AlertsViewModelProtocol {
    @Binding var currentData: CurrentData
    @Binding var actionSheet: MainActionSheet?
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 15)
            ZStack {
                HStack(spacing: 10) {
                    Text("\(currentData.fastest)")
                        .font(.title2)
                        .foregroundColor(.pink)
                        .opacity(viewModel.typeSelected != 0 ? 0.4 : 1)
                    Rectangle()
                        .foregroundColor(.gray)
                        .frame(width: 1)
                    Text("\(currentData.fast)")
                        .font(.title2)
                        .foregroundColor(.blue)
                        .opacity(viewModel.typeSelected != 1 ? 0.4 : 1)
                    Rectangle()
                        .foregroundColor(.gray)
                        .frame(width: 1)
                    Text("\(currentData.average)")
                        .font(.title2)
                        .foregroundColor(.green)
                        .opacity(viewModel.typeSelected != 2 ? 0.4 : 1)
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
                            .foregroundColor(Color("White"))
                            .background(Color("Black"))
                            .cornerRadius(15)
                        
                    }
                    .padding(.horizontal)
                    .frame(height: 30)
                }
            }
            .frame(height: 40)
            VStack {
                Picker(selection: $viewModel.typeSelected, label: Text(Resources.Strings.Alerts.gasType)) {
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
                        Image(systemName: viewModel.currentDirection(currentData: currentData) == .up ? "arrow.up" : "arrow.down")
                            .foregroundColor(viewModel.currentDirection(currentData: currentData) == .up ? .green : .red)
                        Spacer()
                    }
                    TextField(Resources.Strings.Alerts.inputPlaceholder, text: $viewModel.value)
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
                        viewModel.saveAlert(currentData: currentData)
                    }) {
                        Text(Resources.Strings.Alerts.create.uppercased())
                            .frame(minWidth: 0, maxWidth: .infinity)
                    }
                    .disabled(viewModel.value.isEmpty ||
                              viewModel.alertsData.alerts.contains(where: { $0.type == viewModel.currentGasType() && $0.value == Int(viewModel.value) ?? -1 }) ||
                              Int(viewModel.value) ?? 0 <= 0 ||
                              viewModel.alertsData.alerts.count >= 20)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 44, maxHeight: 44)
                    .background(Color.yellow)
                    .foregroundColor(.black)
                    
                    Button(action: {
                        viewModel.showingFrequencySelection = true
                    }) {
                        Text(viewModel.frequency.localized)
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
                ForEach(viewModel.alertsData.alerts) { alert in
                    ItemAlertView(alert: alert)
                }
                .onDelete { indices in
                    let alertGas = viewModel.alertsData.alerts[indices.first ?? 0]
                    self.viewModel.removeAlert(alertGas)
                }
            }
            
            Spacer()
        }
        .sheet(isPresented: $viewModel.showingFrequencySelection) {
            FrequencySelectionView(frequency: $viewModel.frequency)
        }
        .onAppear() {
            viewModel.fetchAlerts()
        }
        .onDisappear() {
            viewModel.removeCurrentAlertsObserver()
        }
    }
}

struct AlertsView_Previews: PreviewProvider {
    static var previews: some View {
        AlertsView(currentData: .constant(CurrentData.dummyData), actionSheet: .constant(.alerts), viewModel: MockAlertsViewModel())
    }
}
