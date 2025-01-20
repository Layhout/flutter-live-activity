//
//  LiveActivitiesAppLiveActivity.swift
//  LiveActivitiesApp
//
//  Created by Layhout Chea on 20/1/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct LiveActivitiesAppAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct LiveActivitiesAppLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveActivitiesAppAttributes.self) { context in
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

extension LiveActivitiesAppAttributes {
    fileprivate static var preview: LiveActivitiesAppAttributes {
        LiveActivitiesAppAttributes(name: "World")
    }
}

extension LiveActivitiesAppAttributes.ContentState {
    fileprivate static var smiley: LiveActivitiesAppAttributes.ContentState {
        LiveActivitiesAppAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: LiveActivitiesAppAttributes.ContentState {
         LiveActivitiesAppAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: LiveActivitiesAppAttributes.preview) {
   LiveActivitiesAppLiveActivity()
} contentStates: {
    LiveActivitiesAppAttributes.ContentState.smiley
    LiveActivitiesAppAttributes.ContentState.starEyes
}
