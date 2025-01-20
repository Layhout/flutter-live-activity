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
        var step: Int
        var distance: Int
        var title: String
        var description: String
    }

    // Fixed non-changing properties about your activity go here!
    var id: String = UUID().uuidString
}

struct LiveActivitiesAppLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveActivitiesAppAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
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
                    Text("Bottom")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T")
            } minimal: {
                Text("M")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension LiveActivitiesAppAttributes {
    fileprivate static var preview: LiveActivitiesAppAttributes {
        LiveActivitiesAppAttributes()
    }
}

extension LiveActivitiesAppAttributes.ContentState {
    fileprivate static var placed: LiveActivitiesAppAttributes.ContentState {
        LiveActivitiesAppAttributes.ContentState(
            step: 0, distance: 3, title: "Order Placed", description: "Your order has been placed"
        )
     }
    
    fileprivate static var prepare: LiveActivitiesAppAttributes.ContentState {
        LiveActivitiesAppAttributes.ContentState(
            step: 1, distance: 3, title: "Preparing Order", description: "We are preparing your order"
        )
     }
    
    fileprivate static var delivering: LiveActivitiesAppAttributes.ContentState {
        LiveActivitiesAppAttributes.ContentState(
            step: 2, distance: 3, title: "Delivering Order", description: "Delivering by 12:30 PM"
        )
     }
    
    fileprivate static var completed: LiveActivitiesAppAttributes.ContentState {
        LiveActivitiesAppAttributes.ContentState(
            step: 3, distance: 3, title: "Completed", description: "Thank you for ordering with us! Enjoy your meal!"
        )
     }
}

#Preview("Notification", as: .content, using: LiveActivitiesAppAttributes.preview) {
   LiveActivitiesAppLiveActivity()
} contentStates: {
    LiveActivitiesAppAttributes.ContentState.placed
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
