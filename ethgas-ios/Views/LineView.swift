//
//  LineView.swift
//  ethgas-ios
//
//  Created by mgarciate on 06/02/2021.
//

import SwiftUI
import Charts

enum GraphType {
    case daily, weekly
}

struct LineView : UIViewRepresentable {
    var entries : [GraphEntry]
    let graphType: GraphType
    let description: String
    private let labels = [
        Resources.Strings.Common.Speed.fastest,
        Resources.Strings.Common.Speed.fast,
        Resources.Strings.Common.Speed.standard
    ]
    private let colors: [NSUIColor] = [.systemPink, .blue, .green]
    // this func is required to conform to UIViewRepresentable protocol
    func makeUIView(context: Context) -> LineChartView {
        //crate new chart
        let chart = LineChartView()
        chart.rightAxis.drawLabelsEnabled = false
        chart.rightAxis.drawAxisLineEnabled = false
        chart.leftAxis.drawZeroLineEnabled = true
        chart.chartDescription.text = description
        
        chart.xAxis.valueFormatter = MyXAxisValueFormatter(graphEntries: entries, graphType: graphType)
        chart.xAxis.granularity = 1.0
        
        //it is convenient to form chart data in a separate func
        chart.data = addData()
        return chart
    }
    
    // this func is required to conform to UIViewRepresentable protocol
    func updateUIView(_ uiView: LineChartView, context: Context) {
        //when data changes chartd.data update is required
        uiView.data = addData()
    }
    
    func addData() -> LineChartData {
        var chartDataEntries = [[ChartDataEntry]]()
        chartDataEntries.append([])
        chartDataEntries.append([])
        chartDataEntries.append([])
        for i in 0..<entries.count {
            chartDataEntries[0].append(ChartDataEntry(x: Double(i), y: Double(entries[i].fastest)))
            chartDataEntries[1].append(ChartDataEntry(x: Double(i), y: Double(entries[i].fast)))
            chartDataEntries[2].append(ChartDataEntry(x: Double(i), y: Double(entries[i].average)))
        }
        
        var dataSets = [LineChartDataSet]()
        for i in 0..<chartDataEntries.count {
            let dataSet = LineChartDataSet(entries: chartDataEntries[i], label: labels[i])
            dataSet.colors = [colors[i]]
            dataSet.circleColors = [colors[i]]
            dataSet.circleRadius = 1
            dataSet.lineWidth = 1
            
            dataSets.append(dataSet)
        }
        
        let data = LineChartData(dataSets: dataSets)
        return data
    }
    
    typealias UIViewType = LineChartView
}



struct Bar_Previews: PreviewProvider {
    static var previews: some View {
        LineView(entries: [
            GraphEntry(timestamp: 0, ethusd: 0, fastest: 0, fast: 0, average: 0),
            GraphEntry(timestamp: 0, ethusd: 0, fastest: 0, fast: 0, average: 0),
            GraphEntry(timestamp: 0, ethusd: 0, fastest: 0, fast: 0, average: 0),
            GraphEntry(timestamp: 0, ethusd: 0, fastest: 0, fast: 0, average: 0)
        ], graphType: .daily, description: "description")
    }
}

fileprivate class MyXAxisValueFormatter: AxisValueFormatter {
    let graphEntries: [GraphEntry]
    let graphType: GraphType
    
    init(graphEntries: [GraphEntry], graphType: GraphType) {
        self.graphEntries = graphEntries
        self.graphType = graphType
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
//        TimeZone tz = Calendar.getInstance().getTimeZone();
//        SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
//        sdf.setTimeZone(tz);
//
//        Measure measure = mValues.get((int)value);
//        return String.format("%s", sdf.format(new Date(measure.getCreatedAt() * 1000)));
        let graphEntry = graphEntries[Int(value)]
        let date = Date(timeIntervalSince1970: TimeInterval(graphEntry.timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current //Set timezone that you want
        dateFormatter.locale = NSLocale.current
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
        switch graphType {
        case .daily:
            dateFormatter.dateFormat = "HH:mm"
        case .weekly:
            dateFormatter.dateFormat = "MMM d\nH:mm"
        }
        return dateFormatter.string(from: date)
    }
}
