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
                    ChartLineMarksView(entries: viewModel.dailyEntries, graphType: .daily)
                        .frame(minHeight: 0, maxHeight: .infinity)
                }
                if viewModel.weeklyEntries.count > 0 {
                    ChartLineMarksView(entries: viewModel.weeklyEntries, graphType: .weekly)
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

enum GraphType {
    case daily, weekly
}

struct ChartLineMarksView: View {
    let entries : [GraphEntry]
    let graphType: GraphType
    @State private var touchLocation: CGPoint? = nil
    var body: some View {
        Chart(entries) {
            LineMark(
                x: .value("Hora", Date(timeIntervalSince1970: TimeInterval($0.timestamp))),
                y: .value(Resources.Strings.Common.Speed.fastest, $0.fastest)
            )
            .foregroundStyle(by: .value("Value", Resources.Strings.Common.Speed.fastest))
            .interpolationMethod(.catmullRom)
            LineMark(
                x: .value("Hora", Date(timeIntervalSince1970: TimeInterval($0.timestamp))),
                y: .value(Resources.Strings.Common.Speed.fast, $0.fast)
            )
            .foregroundStyle(by: .value("Value", Resources.Strings.Common.Speed.fast))
            .interpolationMethod(.catmullRom)
            LineMark(
                x: .value("Hora", Date(timeIntervalSince1970: TimeInterval($0.timestamp))),
                y: .value(Resources.Strings.Common.Speed.standard, $0.average)
            )
            .foregroundStyle(by: .value("Value", Resources.Strings.Common.Speed.standard))
            .interpolationMethod(.catmullRom)
            //                        .symbol {
            //                            Circle()
            //                                .fill(Color.green)
            //                                .frame(width: 4, height: 4)
            //                        }
        }
        .chartForegroundStyleScale ([
            Resources.Strings.Common.Speed.fastest: .pink,
            Resources.Strings.Common.Speed.fast: .blue,
            Resources.Strings.Common.Speed.standard: .green,
        ])
        //                    .chartYScale(domain: viewModel.domainMeasuresFrom...viewModel.domainMeasuresTo)
        .chartXAxis {
            AxisMarks(preset: .extended, values: .automatic) { value in
                AxisValueLabel(format: .dateTime.hour())
                AxisGridLine(centered: true)
            }
        }
        //                    .chartYAxis {
        //                        AxisMarks(preset: .extended, position: .trailing, values: .stride(by: 2))
        //                    }
    }
}
