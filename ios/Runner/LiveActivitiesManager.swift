//
//  LiveActivitiesManager.swift
//  Runner
//
//  Created by Layhout Chea on 15/1/25.
//

import ActivityKit
import Flutter
import Foundation

class LiveActivitiesManager {
    private static var liveActivityId: String?

    private static func isAuthorizedCall(
        result: @escaping FlutterResult, checkId: Bool = true
    ) -> Bool {
        if #available(iOS 16.1, *) {
            if checkId && liveActivityId == nil {
                result(
                    FlutterError(
                        code: "HAVE_NO_LIVE_ACTIVITY",
                        message: "No live activity is currently in progress",
                        details: nil))

                return false
            }
           
            return true
        } else {
            result(
                FlutterError(
                    code: "FEATURE_NOT_SUPPORTED",
                    message: "Live activity supported on 16.1 and higher",
                    details: nil))

            return false
        }
    }

    private static func getActivityContent(
        state: LiveActivitiesAppAttributes.ContentState?, staleIn: Int?
    ) -> ActivityContent<LiveActivitiesAppAttributes.ContentState>? {
        if state == nil {
            return nil
        }

        let staleDate =
            staleIn != nil
            ? Calendar.current.date(
                byAdding: .minute, value: staleIn!, to: Date.now) : nil

        return .init(state: state!, staleDate: staleDate)
    }

    static func startLiveActivity(
        result: @escaping FlutterResult,
        state: LiveActivitiesAppAttributes.ContentState, staleIn: Int?
    ) {
        if !isAuthorizedCall(result: result, checkId: false) {
            return
        }

        var activity: Activity<LiveActivitiesAppAttributes>
        let attributes = LiveActivitiesAppAttributes()
        let activityContent = getActivityContent(state: state, staleIn: staleIn)

        do {
            activity = try Activity.request(
                attributes: attributes,
                content: activityContent!,
                pushType: nil)

            liveActivityId = activity.id
            result(liveActivityId)
        } catch let error {
            result(
                FlutterError(
                    code: "LIVE_ACTIVITY_ERROR",
                    message: "Unable to initiate live activity",
                    details: error.localizedDescription))
        }

    }

    static func updateLiveActivity(
        result: @escaping FlutterResult,
        state: LiveActivitiesAppAttributes.ContentState, staleIn: Int?
    ) {
        if !isAuthorizedCall(result: result) {
            return
        }

        let activityContent = getActivityContent(state: state, staleIn: staleIn)

        Task {
            let activities = await MainActor.run {
                Activity<LiveActivitiesAppAttributes>.activities
            }
            guard
                let activity = activities.first(where: {
                    $0.id == liveActivityId
                })
            else {
                result(
                    FlutterError(
                        code: "ACTIVITY_ERROR", message: "Activity not found",
                        details: nil))
                return
            }

            await activity.update(activityContent!)
        }

        result(nil)
    }

    static func endLiveActivity(
        result: @escaping FlutterResult,
        state: LiveActivitiesAppAttributes.ContentState?, staleIn: Int?,
        dismissalPolicy: ActivityUIDismissalPolicy
    ) {
        if !isAuthorizedCall(result: result) {
            return
        }

        let activityContent = getActivityContent(state: state, staleIn: staleIn)

        Task {
            for activity in Activity<LiveActivitiesAppAttributes>.activities {
                if liveActivityId == activity.id {
                    await activity.end(
                        activityContent, dismissalPolicy: dismissalPolicy)
                }
            }
        }

        result("Success")
    }
}
