//
//  LiveActivitiesController.swift
//  Runner
//
//  Created by Layhout Chea on 20/1/25.
//

import ActivityKit
import Flutter

class LiveActivitiesController: LiveActivitiesControllerProtocol {
    internal static var managerChannel: FlutterMethodChannel? = nil

    public static func register(controller: FlutterViewController) {
        managerChannel = FlutterMethodChannel(
            name: "my.method.channel",
            binaryMessenger: controller.binaryMessenger
        )

        managerChannel?.setMethodCallHandler(handleMethodCall)
    }

    internal static func handleMethodCall(
        call: FlutterMethodCall, result: @escaping FlutterResult
    ) {
        let data = call.arguments as? [String: Any] ?? [String: Any]()

        if #available(iOS 16.1, *) {
            switch call.method {
            case LiveActivitiesActionEnum.isActivitiesAllowed.rawValue:
                LiveActivitiesController.isActivitiesAllowed(result: result)
                break
            case LiveActivitiesActionEnum.startLiveActivity.rawValue:
                LiveActivitiesController.startLiveActivity(
                    result: result, data: data)
                break
            case LiveActivitiesActionEnum.updateLiveActivity.rawValue:
                LiveActivitiesController.updateLiveActivity(
                    result: result, data: data)
                break
            case LiveActivitiesActionEnum.endLiveActivity.rawValue:
                LiveActivitiesController.endLiveActivity(
                    result: result, data: data)
                break
            case LiveActivitiesActionEnum.endAllLiveActivity.rawValue:
                LiveActivitiesController.endAllLiveActivity(result: result)
                break
            case LiveActivitiesActionEnum.getAllActivityIds.rawValue:
                LiveActivitiesController.getAllActivityIds(result: result)
                break
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
    
    internal static func isActivitiesAllowed(result: @escaping FlutterResult){
        LiveActivitiesManager.areLiveActivitiesEnabled(result: result)
    }
    
    internal static func getAllActivityIds(result: @escaping FlutterResult) {
        LiveActivitiesManager.getAllActivityIds(result: result)
    }

    internal static func startLiveActivity(
        result: @escaping FlutterResult, data: [String: Any]
    ) {
        let step: Int = data["step"] as? Int ?? 0
        let distance: Int = data["distance"] as? Int ?? 0
        let title: String = data["title"] as? String ?? ""
        let description: String = data["description"] as? String ?? ""
        let staleInMinutes: Int? = data["staleInMinutes"] as? Int ?? nil

        let initialState = LiveActivitiesAppAttributes.ContentState(
            step: step, distance: distance, title: title,
            description: description)

        LiveActivitiesManager.startLiveActivity(
            result: result, state: initialState, staleIn: staleInMinutes)
    }

    internal static func updateLiveActivity(
        result: @escaping FlutterResult, data: [String: Any]
    ) {
        let activityId: String = data["activityId"] as? String ?? ""

        let step: Int = data["step"] as? Int ?? 0
        let distance: Int = data["distance"] as? Int ?? 0
        let title: String = data["title"] as? String ?? ""
        let description: String = data["description"] as? String ?? ""
        let staleInMinutes: Int? = data["staleInMinutes"] as? Int ?? nil

        let updatedState = LiveActivitiesAppAttributes.ContentState(
            step: step, distance: distance, title: title,
            description: description)

        LiveActivitiesManager.updateLiveActivity(
            result: result, activityId: activityId, state: updatedState,
            staleIn: staleInMinutes)
    }

    internal static func endLiveActivity(
        result: @escaping FlutterResult, data: [String: Any]
    ) {
        let activityId: String = data["activityId"] as? String ?? ""

        let step: Int = data["step"] as? Int ?? 0
        let distance: Int = data["distance"] as? Int ?? 0
        let title: String = data["title"] as? String ?? ""
        let description: String = data["description"] as? String ?? ""
        let staleInMinutes: Int? = data["staleInMinutes"] as? Int ?? nil
        let endInSeconds: Int? = data["endInSecond"] as? Int ?? nil
        let dismissalPolicy: ActivityUIDismissalPolicy =
            endInSeconds != nil
            ? .after(
                Calendar.current.date(
                    byAdding: .second, value: endInSeconds!, to: Date())!)
            : .immediate

        let endedState = LiveActivitiesAppAttributes.ContentState(
            step: step, distance: distance, title: title,
            description: description)

        LiveActivitiesManager.endLiveActivity(
            result: result,
            activityId: activityId,
            state: endedState,
            staleIn: staleInMinutes,
            dismissalPolicy: dismissalPolicy)
    }
    
    internal static func endAllLiveActivity(result: @escaping FlutterResult) {
        LiveActivitiesManager.endAllLiveActivity(result: result)
    }
}
