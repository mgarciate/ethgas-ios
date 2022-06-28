//
//  appwidget.swift
//  appwidget
//
//  Created by mgarciate on 03/04/2021.
//

import WidgetKit
import SwiftUI
import Firebase
import FirebaseDatabase

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), currentData: CurrentData.dummyData)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), currentData: CurrentData.dummyData)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        FirebaseService.retrieveData { result in
            switch result {
            case .success(let currentData):
                let currentDate = Date()
                let entry = SimpleEntry(date: currentDate, currentData: currentData)
                let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 30, to: currentDate)!
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
                print("timeline")
                completion(timeline)
            case .failure(let error):
                print(error.localizedDescription)
                let currentDate = Date()
                let entry = SimpleEntry(date: currentDate, currentData: CurrentData.dummyData)
                let timeline = Timeline(entries: [entry], policy: .atEnd)
                completion(timeline)
            }
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let currentData: CurrentData
}

struct appwidgetEntryView : View {
    var entry: Provider.Entry
    static let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        return formatter
    }()

    var body: some View {
        VStack(spacing: 2) {
            HStack(spacing: 2) {
                ZStack {
                    Color.gray.opacity(0.1)
                    VStack(spacing: 4) {
                        Text("\(entry.currentData.fastest)")
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
                        Text("\(entry.currentData.fast)")
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
                        Text("\(entry.currentData.average)")
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
                        Text(entry.currentData.date, formatter: Self.dateFormat)
                        Text(entry.currentData.date, style: .time)
                    }
                }
            }
        }
        .font(.caption)
        .onAppear() {
            print(entry)
        }
    }
}

@main
struct appwidget: Widget {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let kind: String = "appwidget"
    
    init() {
        FirebaseApp.configure()
    }

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            appwidgetEntryView(entry: entry)
        }
        .configurationDisplayName(Resources.Strings.Common.widgetName)
        .description(Resources.Strings.Widget.description)
        .supportedFamilies([.systemSmall])
    }
}

struct appwidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            appwidgetEntryView(entry: SimpleEntry(date: Date(), currentData: CurrentData.dummyData))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            appwidgetEntryView(entry: SimpleEntry(date: Date(), currentData: CurrentData.dummyData))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            appwidgetEntryView(entry: SimpleEntry(date: Date(), currentData: CurrentData.dummyData))
                    .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}

fileprivate class FirebaseService {
    
    static func retrieveData(completion: @escaping (Result<CurrentData, Error>) -> Void) {
        let ref = Database.database().reference()
        
        ref.child("gasprice/widget/current/values").observeSingleEvent(of: .value) { snapshot in
            // Get user value
            guard let value = snapshot.value as? NSDictionary,
                  let id = value["uid"] as? Int,
                  let ethusd = value["ethusd"] as? Double,
                  let blockNum = value["blockNum"] as? Int,
                  let fastest = value["fastest"] as? Int,
                  let fast = value["fast"] as? Int,
                  let average = value["average"] as? Int,
                  let averageMax24h = value["averageMax24h"] as? Int,
                  let averageMin24h = value["averageMin24h"] as? Int,
                  let fastMax24h = value["fastMax24h"] as? Int,
                  let fastMin24h = value["fastMin24h"] as? Int,
                  let fastestMax24h = value["fastestMax24h"] as? Int,
                  let fastestMin24h = value["fastestMin24h"] as? Int else {
                return
            }
            let currentData = CurrentData(timestamp: id, ethusd: ethusd, blockNum: blockNum,fastest: fastest, fast: fast, average: average, averageMax24h: averageMax24h, averageMin24h: averageMin24h, fastMax24h: fastMax24h, fastMin24h: fastMin24h, fastestMax24h: fastestMax24h, fastestMin24h: fastestMin24h)
            print(currentData)
            completion(.success(currentData))
        }
    }
}
