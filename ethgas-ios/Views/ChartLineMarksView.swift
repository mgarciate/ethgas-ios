//
//  ChartLineMarksView.swift
//  ethgas-ios
//
//  Created by mgarciate on 06/02/2021.
//

import SwiftUI
import Charts

enum GraphType {
    case daily, weekly
}

struct ChartLineMarksView: View {
    let entries : [GraphEntry]
    let graphType: GraphType
    @State private var xLocation: CGFloat?
    @State private var selectedEntry: GraphEntry?
    @State private var xOffset: CGFloat = 0
    @State private var indicatorWidth: CGFloat = 0
    var body: some View {
        Chart(entries) {
            LineMark(
                x: .value("Date", Date(timeIntervalSince1970: TimeInterval($0.timestamp))),
                y: .value(Resources.Strings.Common.Speed.fastest, $0.fastest)
            )
            .foregroundStyle(by: .value("Value", Resources.Strings.Common.Speed.fastest))
            .interpolationMethod(.catmullRom)
            LineMark(
                x: .value("Date", Date(timeIntervalSince1970: TimeInterval($0.timestamp))),
                y: .value(Resources.Strings.Common.Speed.fast, $0.fast)
            )
            .foregroundStyle(by: .value("Value", Resources.Strings.Common.Speed.fast))
            .interpolationMethod(.catmullRom)
            LineMark(
                x: .value("Date", Date(timeIntervalSince1970: TimeInterval($0.timestamp))),
                y: .value(Resources.Strings.Common.Speed.standard, $0.average)
            )
            .foregroundStyle(by: .value("Value", Resources.Strings.Common.Speed.standard))
            .interpolationMethod(.catmullRom)
        }
        .chartForegroundStyleScale ([
            Resources.Strings.Common.Speed.fastest: .pink,
            Resources.Strings.Common.Speed.fast: .blue,
            Resources.Strings.Common.Speed.standard: .green,
        ])
        .chartXAxis {
            AxisMarks(preset: .extended, values: .automatic) { value in
                switch graphType {
                case .daily:
                    AxisValueLabel(format: .dateTime.hour())
                case .weekly:
                    AxisValueLabel(format: .dateTime.day())
                }
                AxisGridLine(centered: true)
            }
        }
        .chartOverlay { proxy in
            GeometryReader { geometry in
                Rectangle().fill(.clear).contentShape(Rectangle())
                    .gesture(DragGesture()
                        .onChanged { value in
                            guard let entry = findClosestData(to: value.location, proxy: proxy, geometry: geometry) else { return }
                            select(entry: entry)
                        }
                        .onEnded { _ in
                            clear()
                        }
                    )
                    .onTapGesture { location in
                        guard let entry = findClosestData(to: location, proxy: proxy, geometry: geometry) else { return }
                        select(entry: entry)
                    }
            }
        }
        .chartBackground { proxy in
            GeometryReader { geometry in
                if let xLocation, let selectedEntry {
                    let lineX = xLocation + geometry[proxy.plotAreaFrame].origin.x
                    let xOffset = max(0, min(geometry[proxy.plotAreaFrame].width - indicatorWidth, lineX - indicatorWidth / 2))
                    Path { path in
                        path.move(to: CGPoint(x: xLocation, y: 0.0))
                        path.addLine(to: CGPoint(x: xLocation, y: geometry[proxy.plotAreaFrame].height))
                    }
                    .stroke(Color.red, lineWidth: 2)
                    VStack {
                        VStack {
                            GeometryReader { _ in
                                VStack(alignment: .center, spacing: 0) {
                                    Text(selectedEntry.dateString)
                                    HStack(spacing: 10) {
                                        Text(selectedEntry.fastest.gasValueString)
                                            .foregroundColor(.pink)
                                        Rectangle()
                                            .foregroundColor(.gray)
                                            .frame(width: 1, height: 10)
                                        Text(selectedEntry.fast.gasValueString)
                                            .foregroundColor(.blue)
                                        Rectangle()
                                            .foregroundColor(.gray)
                                            .frame(width: 1, height: 10)
                                        Text(selectedEntry.average.gasValueString)
                                            .foregroundColor(.green)
                                    }
                                }
                                .padding(5)
                                .background(GeometryReader { childGeometry in
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color("Black"), lineWidth: 2)
                                        .background(Color("White"))
                                        .onAppear() {
                                            indicatorWidth = childGeometry.size.width
                                        }
                                        .onChange(of: selectedEntry) { _ in
                                            indicatorWidth = childGeometry.size.width
                                        }
                                })
                                .cornerRadius(10)
                                .font(.caption)
                                .offset(x: xOffset)
                            }
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .onAppear() {
            
        }
    }
    
    private func findClosestData(to location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) -> GraphEntry? {
        let plotSizeWidth: CGFloat
        if #available(iOS 17.0, *) {
            plotSizeWidth = proxy.plotSize.width
        } else {
            plotSizeWidth = geometry[proxy.plotAreaFrame].width
        }
        guard !entries.isEmpty,
              location.x >= 0,
              location.x < plotSizeWidth,
              let firstTimestamp = entries.last?.timestamp,
              let lastTimestamp = entries.first?.timestamp else { return nil }
        let xScaleFactor = CGFloat(lastTimestamp - firstTimestamp) / plotSizeWidth
        let touchedTimestamp = firstTimestamp + Int(location.x * xScaleFactor)
        guard let entry = entries.min(by: { abs($0.timestamp - touchedTimestamp) < abs($1.timestamp - touchedTimestamp) }) else { return nil }
        xLocation = plotSizeWidth * CGFloat(entry.timestamp - firstTimestamp) / CGFloat(lastTimestamp - firstTimestamp)
        return entry
    }
    
    private func select(entry: GraphEntry) {
        selectedEntry = entry
    }
    
    private func clear() {
        xLocation = nil
        selectedEntry = nil
    }
}

struct ChartLineMarksView_Previews: PreviewProvider {
    static var previews: some View {
        ChartLineMarksView(entries: GraphEntry.dummyDailyData, graphType: .daily)
    }
}
