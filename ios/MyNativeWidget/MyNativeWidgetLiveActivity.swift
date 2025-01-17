//
//  MyNativeWidgetLiveActivity.swift
//  MyNativeWidget
//
//  Created by Layhout Chea on 15/1/25.
//

import ActivityKit
import SwiftUI
import WidgetKit

struct MyNativeWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        //        var emoji: String
        var endTime: Date?
        var step: Int
        var distance: Int
        var title: String
        var description: String
    }

    // Fixed non-changing properties about your activity go here!
    var id: String = UUID().uuidString
}

@available(iOS 16.1, *)
struct MyNativeWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MyNativeWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(context.state.title)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(.white)
                        Text(context.state.description)
                            .font(.system(size: 16, weight: .light))
                            .foregroundStyle(.white)
                            .opacity(0.7)
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    Image("coffee_hub").resizable()
                        .frame(width: 42, height: 42)
                        .clipShape(.rect(cornerRadius: 8))
                }
                ProgressView(
                    value: CGFloat(context.state.step),
                    total: CGFloat(context.state.distance),
                    label: {
                        EmptyView()
                    },
                    currentValueLabel: { EmptyView() }
                ).progressViewStyle(LinearWithImageProgressStyle())
            }
            .padding(12)
            .activityBackgroundTint(Color.black.opacity(0.3))
            .activitySystemActionForegroundColor(Color.white)

        } dynamicIsland: { context in
            //            let timeRange: ClosedRange<Date> =
            //                Date()...(context.state.endTime ?? Date())

            return DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    //                    Text("Trailing")
                    //                    ProgressView(
                    //                        timerInterval: timeRange,
                    //                        countsDown: true,
                    //                        label: {
                    //                            Text("Timer")
                    //                        },
                    //                        currentValueLabel: {
                    //                            Text(timerInterval: timeRange, countsDown: true)
                    //                                .font(.system(size: 16))
                    //                                .minimumScaleFactor(0.8)
                    //                                .contentTransition(
                    //                                    .numericText()
                    //                                ).monospacedDigit()
                    //                        }
                    //                    )
                    //                    .progressViewStyle(.circular).tint(.blue)
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
                //                HStack {
                //                    Text(
                //                        timerInterval: timeRange, countsDown: true,
                //                        showsHours: false
                //                    )
                //                    .minimumScaleFactor(0.8)
                //                    .contentTransition(
                //                        .numericText()
                //                    ).monospacedDigit()
                //                    .multilineTextAlignment(.trailing)
                //                    ProgressView(
                //                        timerInterval: timeRange,
                //                        countsDown: true,
                //                        label: { EmptyView() },
                //                        currentValueLabel: { EmptyView() }
                //                    )
                //                    .progressViewStyle(.circular).tint(.blue)
                //                }
            } minimal: {
                //                Text(context.state.emoji)
                Text("minimal")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
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
                            * min(0.93, max(0.1, fractionCompleted)),
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
