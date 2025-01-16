//
//  TestingWidgetLiveActivity.swift
//  TestingWidget
//
//  Created by Layhout Chea on 16/1/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TestingWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }
    
    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct TestingWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TestingWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("On the way to you").font(.system(size: 20, weight: .bold)).foregroundStyle(.white)
                        Text("Estimated delivery at 13:10").font(.system(size: 16, weight: .light)).foregroundStyle(.white).opacity(0.7)
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    AsyncImage(url: URL(string: "https://images.immediate.co.uk/production/volatile/sites/30/2020/08/flat-white-3402c4f.jpg")) { image in
                        image.resizable()
                    } placeholder: {
                        Color.black.opacity(0.1)
                    }
                    .frame(width: 42, height: 42)
                    .clipShape(.rect(cornerRadius: 8))
                }
                VStack{
                    HStack(alignment: .bottom){
                        Image("moto_delivery").resizable().frame(width: 42, height: 32).frame(maxWidth: .infinity, alignment: .leading)
                        Image("location_marker").resizable().frame(width: 24, height: 24)
                    }.frame(maxWidth: .infinity, alignment: .bottom)
                    ProgressView(value: 50, total: 100, label: { EmptyView() }, currentValueLabel: { EmptyView() }).tint(Color("Brand"))
                }
                
            }
            .padding(12)
            .activityBackgroundTint(Color.black.opacity(0.3))
            .activitySystemActionForegroundColor(Color.white)
            
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

extension TestingWidgetAttributes {
    fileprivate static var preview: TestingWidgetAttributes {
        TestingWidgetAttributes(name: "World")
    }
}

extension TestingWidgetAttributes.ContentState {
    fileprivate static var smiley: TestingWidgetAttributes.ContentState {
        TestingWidgetAttributes.ContentState(emoji: "😀")
    }
    
    fileprivate static var starEyes: TestingWidgetAttributes.ContentState {
        TestingWidgetAttributes.ContentState(emoji: "🤩")
    }
}

#Preview("Notification", as: .content, using: TestingWidgetAttributes.preview) {
    TestingWidgetLiveActivity()
} contentStates: {
    TestingWidgetAttributes.ContentState.smiley
    TestingWidgetAttributes.ContentState.starEyes
}
