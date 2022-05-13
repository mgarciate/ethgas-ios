//
//  ContentView.swift
//  ethgas-watchos WatchKit Extension
//
//  Created by mgarciate on 12/2/22.
//

import SwiftUI
import FirebaseAuth

struct MainView: View {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject var viewModel = MainWatchOSViewModel()
    static let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        return formatter
    }()
    
    var body: some View {
        ZStack {
            VStack(spacing: 2) {
                HStack(spacing: 2) {
                    ZStack {
                        Color.gray.opacity(0.1)
                        VStack(spacing: 4) {
                            Text("\(viewModel.currentData.fastest)")
                                .font(.title2)
                                .foregroundColor(.pink)
                            Rectangle()
                                .foregroundColor(.gray)
                                .frame(height: 1)
                            VStack {
                                Text(Resources.Strings.Common.Speed.fastest.uppercased())
                                Text(Resources.Strings.Common.Speed.fastestSubtitle)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(2)
                    }
                    ZStack {
                        Color.gray.opacity(0.1)
                        VStack(spacing: 4) {
                            Text("\(viewModel.currentData.fast)")
                                .font(.title2)
                                .foregroundColor(.blue)
                            Rectangle()
                                .foregroundColor(.gray)
                                .frame(height: 1)
                            VStack {
                                Text(Resources.Strings.Common.Speed.fast.uppercased())
                                Text(Resources.Strings.Common.Speed.fastSubtitle)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(2)
                    }
                }
                HStack(spacing: 2) {
                    ZStack {
                        Color.gray.opacity(0.1)
                        VStack(spacing: 4) {
                            Text("\(viewModel.currentData.average)")
                                .font(.title2)
                                .foregroundColor(.green)
                            Rectangle()
                                .foregroundColor(.gray)
                                .frame(height: 1)
                            VStack {
                                Text(Resources.Strings.Common.Speed.standard)
                                Text(Resources.Strings.Common.Speed.standardSubtitle)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(2)
                    }
                    ZStack {
                        Color.gray.opacity(0.1)
                        VStack {
                            Image(systemName: "icloud.and.arrow.down")
                            Text(viewModel.currentData.date, formatter: Self.dateFormat)
                            Text(viewModel.currentData.date, style: .time)
                        }
                    }
                }
            }
            .font(.caption)
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .background(
                        Color("Black")
                            .opacity(0.7)
                    )
            }
        }
        .onTapGesture {
            viewModel.fetchData()
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .active:
                viewModel.fetchData()
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
