//
//  TestingWidgetLiveActivity.swift
//  TestingWidget
//
//  Created by Layhout Chea on 16/1/25.
//

import ActivityKit
import SwiftUI
import WidgetKit

struct TestingWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
        var step: Int?
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
                        Text("On the way to you").font(
                            .system(size: 20, weight: .bold)
                        ).foregroundStyle(.white)
                        Text("Estimated delivery at 13:10").font(
                            .system(size: 16, weight: .light)
                        ).foregroundStyle(.white).opacity(0.7)
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    Image("coffee_hub").resizable()
                        .frame(width: 42, height: 42)
                        .clipShape(.rect(cornerRadius: 8))
                }
                VStack {
                    ProgressView(
                        value: CGFloat(context.state.step ?? 0), total: 3,
                        label: { EmptyView() },
                        currentValueLabel: { EmptyView() }
                    )
                    .progressViewStyle(LinearWithImageProgressStyle())
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
    fileprivate static var s0: TestingWidgetAttributes.ContentState {
        TestingWidgetAttributes.ContentState(emoji: "😀", step: 0)
    }

    fileprivate static var s1: TestingWidgetAttributes.ContentState {
        TestingWidgetAttributes.ContentState(emoji: "🤩", step: 1)
    }

    fileprivate static var s2: TestingWidgetAttributes.ContentState {
        TestingWidgetAttributes.ContentState(emoji: "😀", step: 2)
    }

    fileprivate static var s3: TestingWidgetAttributes.ContentState {
        TestingWidgetAttributes.ContentState(emoji: "😀", step: 3)
    }
}

#Preview("Notification", as: .content, using: TestingWidgetAttributes.preview) {
    TestingWidgetLiveActivity()
} contentStates: {
    TestingWidgetAttributes.ContentState.s0
    TestingWidgetAttributes.ContentState.s1
    TestingWidgetAttributes.ContentState.s2
    TestingWidgetAttributes.ContentState.s3
}

struct LinearWithImageProgressStyle: ProgressViewStyle {
    let markerImage: some View = Image("moto_delivery").resizable().frame(
        width: 42, height: 32)
    let goalImage: some View = Image("location_marker").resizable().frame(
        width: 24, height: 24)

    func makeBody(configuration: Configuration) -> some View {
        let fractionCompleted = configuration.fractionCompleted ?? 0

        VStack {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Image("moto_delivery").resizable().frame(
                        width: 42, height: 32
                    ).frame(
                        width: geometry.size.width
                            * min(0.93, max(0.12, fractionCompleted)),
                        alignment: .trailing
                    )
                    Image("location_marker").resizable().frame(
                        width: 24, height: 24
                    ).frame(maxWidth: .infinity, alignment: .trailing)
                }
            }.frame(height: 32)
            ProgressView(value: configuration.fractionCompleted).tint(
                Color("Brand"))
        }
    }
}
