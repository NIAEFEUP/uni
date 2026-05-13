//
//  ScheduleWidget.swift
//  ScheduleWidget
//


import WidgetKit
import SwiftUI

var exampleLectures = [LectureData(subject: "Compiladores", acronym: "C", room: "B310", typeClass: "TP", startTime: "08:30", endTime:"10:30"), LectureData(subject: "Computação Gráfica", acronym: "CG", room: "B001", typeClass: "T", startTime: "10:30", endTime:"12:30")]

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
    return rawString // fallback just in case
}


struct Provider: TimelineProvider {
    
    // method to retrive data from flutter app
    func getLecturesFromFlutter() -> [LectureData] {
        let groupID = Bundle.main.object(forInfoDictionaryKey: "AppGroupID") as? String ?? "group.pt.up.fe.ni.uni"
        let userDefaults = UserDefaults(suiteName: groupID)
        let scheduleJson = userDefaults?.string(forKey: "schedule_data") ?? "[]"
        
        var lectures: [LectureData] = []
        if let data = scheduleJson.data(using: .utf8) {
            do {
                lectures = try JSONDecoder().decode([LectureData].self, from: data)
            } catch {
                print("Failed to decode JSON: \(error)")
            }
        }
        return lectures
    }
    
    // preview in widget gallery
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), lectures: exampleLectures)
    }
    
    // widget gallery/selection preview
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let allLectures = getLecturesFromFlutter()
        completion(SimpleEntry(date: Date(), lectures: Array(allLectures.prefix(2))))
    }
    
    // actual widget on homescreen
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let allLectures = getLecturesFromFlutter()
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let now = Date()
        var entries: [SimpleEntry] = []
        
        // 1. create the current state entry
        let currentLectures = allLectures.filter { lecture in
            if let endDate = dateFormatter.date(from: lecture.endTime) {
                return endDate > now
            }
            return false
        }
        entries.append(SimpleEntry(date: now, lectures: Array(currentLectures.prefix(2))))
        
        // 2. create future entries for the moment each class ends
        for lecture in allLectures {
            if let endDate = dateFormatter.date(from: lecture.endTime), endDate > now {
                let futureLectures = allLectures.filter { nextLecture in
                    if let nextEndDate = dateFormatter.date(from: nextLecture.endTime) {
                        return nextEndDate > endDate
                    }
                    return false
                }
                entries.append(SimpleEntry(date: endDate, lectures: Array(futureLectures.prefix(2))))
            }
        }
        
        // sort entries by date ascending
        entries.sort { $0.date < $1.date }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
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
                    .font(.headline) // Dark Maroon
            } else {
                switch family {
                case .systemSmall:
                    LectureCardView(lecture: entry.lectures.first!, showTime: true)
                case .systemMedium:
                    VStack(spacing: 12) {
                        ForEach(entry.lectures.prefix(2), id: \.self) { lecture in
                            LectureTimelineRow(lecture: lecture)
                                .frame(maxHeight: .infinity)
                        }
                    }
                    .padding(12)
                default:
                    Text("Unsupported Size")
                }
            }
        }
    }
}

// MARK: - Medium Widget Row (Timeline Style)
struct LectureTimelineRow: View {
    @Environment(\.colorScheme) var colorScheme
    let lecture: LectureData
    
    var accentColor: Color {
        WidgetPalette.accentColor(for: colorScheme)
    }
    
    var textColor: Color {
        WidgetPalette.primaryTextColor(for: colorScheme)
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            
            // 1. Time Column (Stays at the top)
            VStack(alignment: .trailing) {
                Text(formatTime(lecture.startTime))
                    .font(.caption).bold()
                    .foregroundColor(textColor)
                    .padding(.top, 4)
                
            }
            .frame(width: 40, alignment: .center)
            
            // 2. Timeline Line & Circle
            VStack(spacing: 0) {
                Circle()
                    .strokeBorder(accentColor, lineWidth: 3)
                    .frame(width: 12, height: 12)
                    .padding(.top, 2)
                
                // This stretches the line to the bottom of the row
                Rectangle()
                    .fill(accentColor)
                    .frame(width: 2)
                    .frame(maxHeight: .infinity)
            }
            
            // 3. The Details Card
            MediumLectureCardView(lecture: lecture)
                .frame(maxHeight: .infinity)
        }
    }
    
    
}

// MARK: - Inner Card & Small Widget View
struct LectureCardView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.widgetRenderingMode) var renderingMode
    
    let lecture: LectureData
    var showTime: Bool = true
    
    // Theme Colors
    var accentColor: Color {
        WidgetPalette.accentColor(for: colorScheme)
    }
    
    var primaryTextColor: Color {
        WidgetPalette.primaryTextColor(for: colorScheme)
    }
    
    var subtleTextColor: Color {
        WidgetPalette.subtleTextColor(for: colorScheme)
    }
    
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            
            HStack {
                if showTime {
                    Text(formatTime(lecture.startTime))
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(primaryTextColor)
                        .padding(.vertical, 2)
                    
                }
                
                Spacer(minLength: 0)
                
                Text(lecture.typeClass)
                    .font(.caption).bold()
                    .foregroundColor(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background {
                        if renderingMode == .fullColor {
                            WidgetPalette.typeClassColor(lecture.typeClass)
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

// MARK: - Medium Inner Card
struct MediumLectureCardView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.widgetRenderingMode) var renderingMode
    
    let lecture: LectureData
    
    var accentColor: Color {
        WidgetPalette.accentColor(for: colorScheme)
    }
    var primaryTextColor: Color { WidgetPalette.primaryTextColor(for: colorScheme) }
    var subtleTextColor: Color { WidgetPalette.subtleTextColor(for: colorScheme) }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            
            HStack(alignment: .center) {
                
                // acronym
                Text(lecture.acronym)
                    .font(.title3)
                    .bold()
                    .foregroundColor(primaryTextColor)
                
                // class type
                Text(lecture.typeClass)
                    .font(.caption).bold()
                    .foregroundColor(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background {
                        if renderingMode == .fullColor {
                            WidgetPalette.typeClassColor(lecture.typeClass)
                        } else {
                            Color.secondary.opacity(0.3)
                        }
                    }
                    .clipShape(Capsule())
                    .widgetAccentable()
                
                Spacer(minLength: 0)
                
                // room
                HStack(spacing: 4) {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(accentColor)
                        .font(.subheadline)
                    Text(lecture.room)
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(primaryTextColor)
                }
            }
            
            // subject
            Text(lecture.subject)
                .font(.caption)
                .foregroundColor(subtleTextColor)
                .lineLimit(1)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(
            ContainerRelativeShape().fill(
                Color.secondary.opacity(colorScheme == .dark ? 0.15 : 0.05)))
    }
}

struct WidgetBackgroundView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        WidgetPalette.backgroundColor(for: colorScheme)
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
        .configurationDisplayName("Schedule")
        .description("See your upcoming lectures.")
        .supportedFamilies([.systemSmall, .systemMedium])
        .contentMarginsDisabled()
    }
}



#Preview(as: .systemSmall) {
    ScheduleWidget()
} timeline: {
    SimpleEntry(date: .now, lectures: exampleLectures)
}
