//
//  MainView.swift
//  ethgas-ios
//
//  Created by mgarciate on 04/01/2021.
//

import SwiftUI
import AuthenticationServices

struct MainView<ViewModel, AlertsViewModel, HotViewModel, ChartsViewModel>: View where ViewModel: MainViewModelProtocol, AlertsViewModel: AlertsViewModelProtocol, HotViewModel: HotViewModelProtocol, ChartsViewModel: ChartsViewModelProtocol {
    @StateObject var viewModel: ViewModel
    @State var actionSheet: MainActionSheet?
    let alertsViewModel: AlertsViewModel
    let hotViewModel: HotViewModel
    let chartsViewModel: ChartsViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            HStack {
                Text(Resources.Strings.Common.appName)
                    .font(Font.title.bold())
                Spacer()
                HStack {
                    Button(action: {
                        if viewModel.isSignedIn {
                            viewModel.signInWithAppleButtonTapped()
                        } else {
                            actionSheet = .hot
                        }
                    }) {
                        Image(systemName: "thermometer")
                            .resizable()
                            .scaledToFit()
                            .padding(10)
                            .frame(width: 50, height: 50)
                            .foregroundColor(Color("White"))
                            .background(Color("Black"))
                            .cornerRadius(25)
                    }
                    Button(action: {
                        if viewModel.isSignedIn {
                            viewModel.signInWithAppleButtonTapped()
                        } else {
                            actionSheet = .graphs
                        }
                    }) {
                        Image("timeline")
                            .resizable()
                            .scaledToFit()
                            .padding(10)
                            .foregroundColor(Color("White"))
                            .background(Color("Black"))
                            .cornerRadius(25)
                    }
                    Button(action: {
                        if viewModel.isSignedIn {
                            viewModel.signInWithAppleButtonTapped()
                        } else {
                            actionSheet = .alerts
                        }
                    }) {
                        Image(systemName: "alarm")
                            .resizable()
                            .scaledToFit()
                            .padding(10)
                            .foregroundColor(Color("White"))
                            .background(Color("Black"))
                            .cornerRadius(25)
                    }
                }
                .frame(height: 50)
            }
            HStack {
                Text(Resources.Strings.Main.header)
                Spacer()
            }
            
            if viewModel.isSignedIn {
                SignInWithAppleButton()
                    .frame(width: 280, height: 45)
                    .onTapGesture { // (1)
                        viewModel.signInWithAppleButtonTapped() // (2)
                    }
                Text(Resources.Strings.Main.signinRequired)
                    .foregroundColor(.gray)
                    .padding(.top, -15)
            } else {
                VStack {
                    CardValueView(viewModel: CardValueViewModel(value: viewModel.currentData.fastest, color: .pink, title: Resources.Strings.Common.Speed.fastest.uppercased(), subtitle: Resources.Strings.Common.Speed.fastestSubtitle))
                    CardValueView(viewModel: CardValueViewModel(value: viewModel.currentData.fast, color: .blue, title: Resources.Strings.Common.Speed.fast.uppercased(), subtitle: Resources.Strings.Common.Speed.fastSubtitle))
                    CardValueView(viewModel: CardValueViewModel(value: viewModel.currentData.average, color: .green, title: Resources.Strings.Common.Speed.standard.uppercased(), subtitle: Resources.Strings.Common.Speed.standardSubtitle))
                    
                    HStack {
                        Text("1 ETH = \(String(format: "%.1f", viewModel.currentData.ethusd)) USD")
                        Button(action: {
                            actionSheet = .fees
                        }) {
                            Image("dollar")
                                .resizable()
                                .scaledToFit()
                                .padding(5)
                                .foregroundColor(Color("White"))
                                .background(Color("Black"))
                                .cornerRadius(15)
                        }
                        .frame(height: 30)
                    }
                    Spacer()
                        .frame(height: 10)
                    
                    HStack(spacing: 30) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(Resources.Strings.Main._24hMax)
                            Text(Resources.Strings.Main._24hMin)
                        }
                        VStack(spacing: 5) {
                            Text(viewModel.currentData.fastestMax24h.gasValueString)
                            Text(viewModel.currentData.fastestMin24h.gasValueString)
                        }
                        .foregroundColor(.pink)
                        VStack(spacing: 5) {
                            Text(viewModel.currentData.fastMax24h.gasValueString)
                            Text(viewModel.currentData.fastMin24h.gasValueString)
                        }
                        .foregroundColor(.blue)
                        VStack(spacing: 5) {
                            Text(viewModel.currentData.averageMax24h.gasValueString)
                            Text(viewModel.currentData.averageMin24h.gasValueString)
                        }
                        .foregroundColor(.green)
                    }
                    .padding(10)
                    .border(Color.black, width: 1)
                    
                    Spacer()
                    HStack {
                        Spacer()
                        HStack {
                            VStack(alignment: .trailing) {
                                Label("\(Bundle.main.appVersion() ?? "") - \(viewModel.currentData.dateString)", systemImage: "icloud.and.arrow.down")
                                    .font(.caption)
                                Button(Resources.Strings.Common.signOut) {
                                    viewModel.signOut()
                                }
                            }
                        }
                    }
                }
            }
            Spacer()
        }
        .padding()
        .sheet(item: $actionSheet) { item in
            switch(item) {
            case .alerts:
                AlertsView(currentData: $viewModel.currentData, actionSheet: $actionSheet, viewModel: alertsViewModel)
                    .navigationTitle(Resources.Strings.Alerts.title)
            case .graphs:
                ChartsView(actionSheet: $actionSheet, viewModel: chartsViewModel)
            case .hot:
                HotView<HotViewModel>(actionSheet: $actionSheet, viewModel: hotViewModel)
            case .fees:
                FeesView(currentData: $viewModel.currentData, actionSheet: $actionSheet)
            }
        }
        .alert(isPresented: $viewModel.isMigrationAlertPresented) {
            Alert(title: Text(Resources.Strings.Common.appName),
                  message: Text(Resources.Strings.Migration.v150.message),
                  primaryButton: .cancel(),
                  secondaryButton: .destructive(Text(Resources.Strings.Common.signOut)) {
                viewModel.signOut()
            }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MockMainViewModel(isSignedIn: false), alertsViewModel: MockAlertsViewModel(), hotViewModel: MockHotViewModel(), chartsViewModel: MockChartsViewModel())
    }
}
