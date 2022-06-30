//
//  appwidget.swift
//  appwidget
//
//  Created by mgarciate on 03/04/2021.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), currentData: CurrentData.dummyData)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), currentData: CurrentData.dummyData)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            do {
                let currentData = try await NetworkService<CurrentData>().get(endpoint: "gasprice/current")
                let currentDate = Date()
                let entry = SimpleEntry(date: currentDate, currentData: currentData)
                let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 30, to: currentDate)!
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
                completion(timeline)
                return
            } catch {
                #if DEBUG
                print("Error", error)
                #endif
                let currentDate = Date()
                let entry = SimpleEntry(date: currentDate, currentData: CurrentData.defaultData)
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
            #if DEBUG
            print(entry)
            #endif
        }
    }
}

@main
struct appwidget: Widget {
    let kind: String = "appwidget"

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
