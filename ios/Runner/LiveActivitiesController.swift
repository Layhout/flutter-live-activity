//
//  LiveActivitiesController.swift
//  Runner
//
//  Created by Layhout Chea on 20/1/25.
//

import ActivityKit
import Flutter

class LiveActivitiesController {
    private static var managerChannel: FlutterMethodChannel? = nil

    public static func register(controller: FlutterViewController) {
        managerChannel = FlutterMethodChannel(
            name: "my.method.channel",
            binaryMessenger: controller.binaryMessenger
        )

        managerChannel?.setMethodCallHandler(handleMethodCall)
    }

    private static func handleMethodCall(
        call: FlutterMethodCall, result: @escaping FlutterResult
    ) {
        let data = call.arguments as? [String: Any] ?? [String: Any]()

        if #available(iOS 16.1, *) {
            switch call.method {
            case "startLiveActivity":
                LiveActivitiesController.startLiveActivity(
                    result: result, data: data)
                break
            case "updateLiveActivity":
                LiveActivitiesController.updateLiveActivity(
                    result: result, data: data)
                break
            case "endLiveActivity":
                LiveActivitiesController.endLiveActivity(
                    result: result, data: data)
                break
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }

    private static func startLiveActivity(
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

    private static func updateLiveActivity(
        result: @escaping FlutterResult, data: [String: Any]
    ) {
        let step: Int = data["step"] as? Int ?? 0
        let distance: Int = data["distance"] as? Int ?? 0
        let title: String = data["title"] as? String ?? ""
        let description: String = data["description"] as? String ?? ""
        let staleInMinutes: Int? = data["staleInMinutes"] as? Int ?? nil

        let updatedState = LiveActivitiesAppAttributes.ContentState(
            step: step, distance: distance, title: title,
            description: description)

        LiveActivitiesManager.updateLiveActivity(
            result: result, state: updatedState, staleIn: staleInMinutes)
    }

    private static func endLiveActivity(
        result: @escaping FlutterResult, data: [String: Any]
    ) {
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
            state: endedState,
            staleIn: staleInMinutes,
            dismissalPolicy: dismissalPolicy)
    }
}
