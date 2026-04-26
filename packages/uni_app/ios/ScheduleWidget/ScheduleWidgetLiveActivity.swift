//
//  ScheduleWidgetLiveActivity.swift
//  ScheduleWidget
//


import ActivityKit
import WidgetKit
import SwiftUI

struct ScheduleWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct ScheduleWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ScheduleWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension ScheduleWidgetAttributes {
    fileprivate static var preview: ScheduleWidgetAttributes {
        ScheduleWidgetAttributes(name: "World")
    }
}

extension ScheduleWidgetAttributes.ContentState {
    fileprivate static var smiley: ScheduleWidgetAttributes.ContentState {
        ScheduleWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: ScheduleWidgetAttributes.ContentState {
         ScheduleWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: ScheduleWidgetAttributes.preview) {
   ScheduleWidgetLiveActivity()
} contentStates: {
    ScheduleWidgetAttributes.ContentState.smiley
    ScheduleWidgetAttributes.ContentState.starEyes
}
