//
//  MyNativeWidgetLiveActivity.swift
//  MyNativeWidget
//
//  Created by Layhout Chea on 15/1/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct MyNativeWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
//        var emoji: String
        var endTime: Date?
    }
    
    // Fixed non-changing properties about your activity go here!
    var id: String = UUID().uuidString
}

@available(iOS 16.1, *)
struct MyNativeWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MyNativeWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
//                Text("Hello \(context.state.emoji)")
//                Text("Hello Simple Timer")
//                Text(timerInterval: Date()...(context.state.endTime ?? Date()), countsDown: true).multilineTextAlignment(.center)
            }
            .padding(12)
            .activityBackgroundTint(Color.black.opacity(0.5))
            .activitySystemActionForegroundColor(Color.white)
            
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
//                    Text("Trailing")
                    ProgressView(
                        timerInterval: Date()...(context.state.endTime ?? Date()),
                        countsDown: true,
                        label: { Text("Timer") },
                        currentValueLabel: { Text(timerInterval: Date()...(context.state.endTime ?? Date()), countsDown: true).font(.system(size: 16)) }
                    )
                    .progressViewStyle(.circular).tint(.blue)
                }
                DynamicIslandExpandedRegion(.bottom) {
//                    Text("Bottom \(context.state.emoji)")
                    Text("Bottom")
                    // more content
                }
            } compactLeading: {
                Text("Timer")
            } compactTrailing: {
//                Text("T \(context.state.emoji)")
                //                ProgressView(value: 0.5, total: 1) {
                //                    let healthLevel = Int(0.5 * 100)
                //                    Text("0.5")
                //                        .accessibilityLabel("Health level at 0.5 percent.")
                //                }
                //                .progressViewStyle(.circular)
                //                .tint(Color.green)
                HStack {
                    Text(timerInterval: Date()...(context.state.endTime ?? Date()), countsDown: true).multilineTextAlignment(.trailing)
                    ProgressView(
                        timerInterval: Date()...(context.state.endTime ?? Date()),
                        countsDown: true,
                        label: { EmptyView() },
                        currentValueLabel: { EmptyView() }
                    )
                    .progressViewStyle(.circular).tint(.blue)
                }
            } minimal: {
//                Text(context.state.emoji)
                Text("minimal")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

struct Widget_Previews: PreviewProvider {

  static var previews: some View {
    VStack {
        
    }
    .containerBackground(Color.black.opacity(0), for: .widget)
    .previewContext(WidgetPreviewContext(family: .systemSmall))
  }
}
