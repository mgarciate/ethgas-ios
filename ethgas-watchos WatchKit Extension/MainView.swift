//
//  ContentView.swift
//  ethgas-watchos WatchKit Extension
//
//  Created by mgarciate on 12/2/22.
//

import SwiftUI

struct MainView: View {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject var viewModel = MainWatchViewModel()
    
    var body: some View {
        ZStack {
            MainMiniView(currentData: $viewModel.currentData)
            if viewModel.isLoading {
                VStack {
                    ProgressView()
                        .progressViewStyle(.circular)
                        
                    Text(Bundle.main.appVersion() ?? "")
                        .foregroundColor(Color("White"))
                }.background(
                    Color("Black")
                        .opacity(0.7)
                )
            }
        }
        .onAppear() {
            viewModel.loadData()
        }
        .onTapGesture {
            viewModel.loadData()
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .active:
                viewModel.loadData()
            default:
                print(">> do nothing")
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        return Group {
//            MainView()
//                .previewDevice("Apple Watch Series 7 - 45mm")
            MainView()
                .previewDevice("Apple Watch Series 7 - 41mm")
        }
    }
}
