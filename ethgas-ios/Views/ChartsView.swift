//
//  ChartsView.swift
//  ethgas-ios
//
//  Created by mgarciate on 06/02/2021.
//

import SwiftUI
import Charts

struct ChartsView<ViewModel>: View where ViewModel: ChartsViewModelProtocol {
    @Binding var actionSheet: MainActionSheet?
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            HStack {
                Image("Icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                Text(Resources.Strings.Common.appName)
                    .font(Font.title3.bold())
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
                .frame(height: 30)
            }
            .padding(.horizontal)
            .padding(.top, 10)
            VStack {
                if viewModel.dailyEntries.count > 0 {
                    GroupBox(Resources.Strings.Charts._24h) {
                        ChartLineMarksView(entries: viewModel.dailyEntries, graphType: .daily)
                    }
                    .frame(minHeight: 0, maxHeight: .infinity)
                }
                if viewModel.weeklyEntries.count > 0 {
                    GroupBox(Resources.Strings.Charts._7d) {
                        ChartLineMarksView(entries: viewModel.weeklyEntries, graphType: .weekly)
                    }
                    .frame(minHeight: 0, maxHeight: .infinity)
                }
                Spacer()
            }
            .padding([.horizontal, .bottom])
        }
        .onAppear() {
            viewModel.fetchGraphs()
        }
    }
}

struct ChartsView_Previews: PreviewProvider {
    static var previews: some View {
        ChartsView(actionSheet: .constant(.graphs), viewModel: MockChartsViewModel())
    }
}
