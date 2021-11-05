//
//  MainView.swift
//  ethgas-ios
//
//  Created by mgarciate on 04/01/2021.
//

import SwiftUI
import AuthenticationServices

enum MainActionSheet: Identifiable {
    case alerts, graphs, hot, fees
    
    var id: Int {
        hashValue
    }
}

struct MainView: View {
    @StateObject var viewModel = MainViewModel()
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var signInHandler: SignInWithAppleCoordinator?
    @State var actionSheet: MainActionSheet?
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            HStack {
                Text(Resources.Strings.Common.appName)
                    .font(Font.title.bold())
                Spacer()
                HStack {
                    Button(action: {
                        if viewModel.isSignedIn {
                            signInWithAppleButtonTapped()
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
                            signInWithAppleButtonTapped()
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
                            signInWithAppleButtonTapped()
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
                        self.signInWithAppleButtonTapped() // (2)
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
                            Text("\(viewModel.currentData.fastestMax24h)")
                            Text("\(viewModel.currentData.fastestMin24h)")
                        }
                        .foregroundColor(.pink)
                        VStack(spacing: 5) {
                            Text("\(viewModel.currentData.fastMax24h)")
                            Text("\(viewModel.currentData.fastMin24h)")
                        }
                        .foregroundColor(.blue)
                        VStack(spacing: 5) {
                            Text("\(viewModel.currentData.averageMax24h)")
                            Text("\(viewModel.currentData.averageMin24h)")
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
                                Label("\(viewModel.currentData.dateString)", systemImage: "icloud.and.arrow.down")
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
                AlertsView(currentData: $viewModel.currentData, actionSheet: $actionSheet, alertsData: AlertsGas.Data(alerts: []))
                    .navigationTitle(Resources.Strings.Alerts.title)
            case .graphs:
                ChartsView(actionSheet: $actionSheet)
            case .hot:
                HotView(actionSheet: $actionSheet)
            case .fees:
                FeesView(currentData: $viewModel.currentData, actionSheet: $actionSheet)
            }
        }
    }
    
    func signInWithAppleButtonTapped() {
        signInHandler = SignInWithAppleCoordinator(window: window)
        signInHandler?.signIn { (user) in
            #if DEBUG
            print("User signed in \(user.uid)")
            #endif
            self.presentationMode.wrappedValue.dismiss() // (3)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
