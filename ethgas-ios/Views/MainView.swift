//
//  MainView.swift
//  ethgas-ios
//
//  Created by mgarciate on 04/01/2021.
//

import SwiftUI
import AuthenticationServices

enum MainActionSheet: Identifiable {
    case alerts, graphs, hot
    
    var id: Int {
        hashValue
    }
}

struct MainView: View {
    @ObservedObject var viewModel = MainViewModel()
    
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var signInHandler: SignInWithAppleCoordinator?
    @State var actionSheet: MainActionSheet?
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            HStack {
                Text("ETHGas Alerts")
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
                            .foregroundColor(.white)
                            .background(Color.black)
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
                            .foregroundColor(.white)
                            .background(Color.black)
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
                            .foregroundColor(.white)
                            .background(Color.black)
                            .cornerRadius(25)
                    }
                }
                .frame(height: 50)
            }
            HStack {
                Text("Recommended Gas Prices in Gwei")
                Spacer()
            }
            
            if viewModel.isSignedIn {
                SignInWithAppleButton()
                    .frame(width: 280, height: 45)
                    .onTapGesture { // (1)
                        self.signInWithAppleButtonTapped() // (2)
                    }
                Text("(Sign in required to manage alerts)")
                    .foregroundColor(.gray)
                    .padding(.top, -15)
            } else {
                VStack {
                    CardValueView(viewModel: CardValueViewModel(value: viewModel.currentData.fastest, color: .pink, title: "FASTEST", subtitle: "< ASAP"))
                    CardValueView(viewModel: CardValueViewModel(value: viewModel.currentData.fast, color: .blue, title: "FAST", subtitle: "< 2m"))
                    CardValueView(viewModel: CardValueViewModel(value: viewModel.currentData.average, color: .green, title: "STANDARD", subtitle: "< 5m"))
                    
                    Text("1 ETH = \(String(format: "%.1f", viewModel.currentData.ethusd)) USD")
                    Spacer()
                        .frame(height: 10)
                    HStack(spacing: 30) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("24h Max")
                            Text("24h Min")
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
                                Button("Sign out") {
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
                    .navigationTitle("Alerts")
            case .graphs:
                ChartsView(actionSheet: $actionSheet)
            case .hot:
                HotView(actionSheet: $actionSheet)
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

final class CardValueViewModel: ObservableObject {
    @Published var value: Int
    let color: Color
    let title: String
    let subtitle: String
    
    init(value: Int, color: Color, title: String, subtitle: String) {
        self.value = value
        self.color = color
        self.title = title
        self.subtitle = subtitle
    }
}

struct CardValueView: View {
    @ObservedObject var viewModel: CardValueViewModel
    
    var body: some View {
        HStack {
            Text("\(viewModel.value)")
                .frame(minWidth: 70)
                .font(.title)
                .foregroundColor(viewModel.color)
            Rectangle()
                .foregroundColor(.gray)
                .frame(width: 1)
            Spacer()
                .frame(width: 20)
            HStack {
                Text("\(viewModel.title)")
                Text("\(viewModel.subtitle)")
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 50)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(20)
    }
}
