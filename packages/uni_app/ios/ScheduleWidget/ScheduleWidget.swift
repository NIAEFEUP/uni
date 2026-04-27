//
//  ScheduleWidget.swift
//  ScheduleWidget
//


import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    
    // method to retrive data from flutter app
    func getDataFromFlutter() -> SimpleEntry {
        let userDefaults = UserDefaults(suiteName: "group.uniApp")
        let scheduleJson = userDefaults?.string(forKey: "schedule_data") ?? "No data!"
        
        var lectures: [LectureData] = []
        if let data = scheduleJson.data(using: .utf8) {
            do {
                lectures = try JSONDecoder().decode([LectureData].self, from: data)
            } catch {
                print("Failed to decode JSON: \(error)")
            }
        }
        
        return SimpleEntry(date: Date(), lectures: lectures)
    }
    
    // preview in widget gallery
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), lectures: [LectureData(subject: "Compiladores", acronym: "C", room: "B310", typeClass: "TP", teacherName: "João Bispo", startTime: "8:30", endTime:"10:30")])
    }
    
    // widget gallery/selection preview
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = getDataFromFlutter()
        completion(entry)
    }
    
    // actual widget on homescreen
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let entry = getDataFromFlutter()
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
    
}


// the data structure for the widget
struct SimpleEntry: TimelineEntry {
    let date: Date
    let lectures: [LectureData]
}

// view that defines how the widget looks
struct ScheduleWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry
    
    var body: some View {
        Group {
            if entry.lectures.isEmpty {
                Text("No classes ahead! 🍻") // Empty state
                    .font(.headline)
                    .foregroundColor(Color(red: 0.4, green: 0.1, blue: 0.1)) // Dark Maroon
            } else {
                switch family {
                case .systemSmall:
                    // Display ONLY the first lecture
                    LectureCardView(lecture: entry.lectures.first!)
                case .systemMedium:
                    // Display up to exactly 2 lectures in a timeline
                    HStack(spacing: 12) {
                        VStack(spacing: 8) {
                            ForEach(entry.lectures.prefix(2), id: \.acronym) { lecture in
                                LectureTimelineRow(lecture: lecture)
                            }
                        }
                    }
                default:
                    Text("Unsupported Size")
                }
            }
        }
        
    }
}

// MARK: - Medium Widget Row (Timeline Style)
struct LectureTimelineRow: View {
    let lecture: LectureData
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            // 1. Time Column
            VStack {
                Text(formatTime(from: lecture.startTime))
                    .font(.caption).bold()
                    .foregroundColor(Color(red: 0.4, green: 0.1, blue: 0.1))
                Text(formatTime(from: lecture.endTime))
                    .font(.caption2)
                    .foregroundColor(Color(red: 0.4, green: 0.1, blue: 0.1))
            }
            .frame(width: 40)
            
            // 2. Timeline Line & Circle
            VStack(spacing: 0) {
                Circle()
                    .strokeBorder(Color(red: 0.4, green: 0.1, blue: 0.1), lineWidth: 3)
                    .frame(width: 12, height: 12)
                Rectangle()
                    .fill(Color(red: 0.4, green: 0.1, blue: 0.1))
                    .frame(width: 3)
            }
            
            // 3. The Details Card
            LectureCardView(lecture: lecture)
        }
    }
    
    // Helper to format ISO8601 into "HH:mm"
    func formatTime(from isoString: String) -> String {
        let formatter = ISO8601DateFormatter()
        // If your string includes fractional seconds, you might need formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatter.date(from: isoString) {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            return timeFormatter.string(from: date)
        }
        return "00:00"
    }
}

// MARK: - Inner Card & Small Widget View
struct LectureCardView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.widgetRenderingMode) var renderingMode
    
    let lecture: LectureData
    
    // Theme Colors
    var accentColor: Color {
        colorScheme == .dark ? Color(red: 229/255, green: 200/255, blue: 199/255) : Color(red: 0.4, green: 0.1, blue: 0.1)
    }
    
    var primaryTextColor: Color {
        colorScheme == .dark ? .white : .black
    }
    
    var subtleTextColor: Color {
        colorScheme == .dark ? Color(red: 229/255, green: 200/255, blue: 199/255) : .secondary
    }
    
    // helper to extract just HH:MM from the Dart date string
    func formatTime(_ rawString: String) -> String {
        // splitting "2026-04-27 08:30:00.000" by spaces
        let components = rawString.split(separator: " ")
        if components.count > 1 {
            // now we have "08:30:00.000", split by colon
            let timeComponents = components[1].split(separator: ":")
            if timeComponents.count >= 2 {
                return "\(timeComponents[0]):\(timeComponents[1])"
            }
        }
        return rawString // Fallback just in case
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            
            HStack {
                Text(formatTime(lecture.startTime))
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(primaryTextColor)
                    .padding(.vertical, 2)
                
                Spacer()
                
                Text(lecture.typeClass)
                    .font(.caption).bold()
                    .foregroundColor(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background {
                        if renderingMode == .fullColor {
                            lecture.typeClass == "T" ? Color.orange : Color.brown
                        } else {
                            // 2hen in clear/tinted mode, use a vibrant overlay
                            Color.secondary.opacity(0.3)
                        }
                    }
                    .clipShape(Capsule())
                    .widgetAccentable()
                
            }
            
            Spacer()
            
            Text(lecture.acronym)
                .font(.title3)
                .bold()
                .foregroundColor(primaryTextColor)
            
            
            Text(lecture.subject)
                .font(.caption)
                .foregroundColor(subtleTextColor)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
            
            
            // Room
            HStack {
                Spacer()
                Image(systemName: "mappin.circle.fill")
                    .foregroundColor(accentColor)
                Text(lecture.room)
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(primaryTextColor)
            }
            .padding(.bottom,2)
            
            
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        
        
    }
}

struct WidgetBackgroundView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        if colorScheme == .dark {
            Color(red: 47/255, green: 19/255, blue: 19/255)
        } else {
            Color(red: 255/255, green: 245/255, blue: 243/255)
        }
    }
}

// the main widget configuration
struct ScheduleWidget: Widget {
    let kind: String = "ScheduleWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ScheduleWidgetEntryView(entry: entry)
                .containerBackground(for: .widget) {
                    WidgetBackgroundView()
                }
        }
        .supportedFamilies([.systemSmall, .systemMedium])
        .contentMarginsDisabled()
    }
}



#Preview(as: .systemSmall) {
    ScheduleWidget()
} timeline: {
    SimpleEntry(date: .now, lectures: [LectureData(subject: "Compiladores", acronym: "C", room: "B310", typeClass: "TP", teacherName: "João Bispo", startTime: "8:30", endTime:"10:30")])
    SimpleEntry(date: .now, lectures: [LectureData(subject: "Compiladores", acronym: "C", room: "B310", typeClass: "TP", teacherName: "João Bispo", startTime: "8:30", endTime:"10:30")])
}
