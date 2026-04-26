//
//  ScheduleWidget.swift
//  ScheduleWidget
//


import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    
    // method to retrive data from flutter app
    func getDataFromFlutter() -> SimpleEntry {
        let userDefaults = UserDefaults(suiteName: "group.uniApp")
        let scheduleJson = userDefaults?.string(forKey: "schedule_data") ?? "No data!"
        
        return SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), scheduleInfo: scheduleJson)
    }
 
    // preview in widget gallery
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), scheduleInfo: "No data")
    }

    // widget gallery/selection preview
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        getDataFromFlutter()
    }
    
    // actual widget on homescreen
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        
        let entry = getDataFromFlutter()

        return Timeline(entries: [entry], policy: .atEnd)
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}


// the data structure for the widget
struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let scheduleInfo: String
}

// view that defines how the widget looks
struct ScheduleWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Time:")
            Text(entry.date, style: .time)

            Text(entry.scheduleInfo)
        }
    }
}

// the main widget configuration
struct ScheduleWidget: Widget {
    let kind: String = "ScheduleWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            ScheduleWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    ScheduleWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley, scheduleInfo: "No data")
    SimpleEntry(date: .now, configuration: .starEyes, scheduleInfo: "No data")
}
