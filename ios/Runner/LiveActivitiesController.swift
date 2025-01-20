//
//  LiveActivitiesController.swift
//  Runner
//
//  Created by Layhout Chea on 20/1/25.
//

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

    private static func handleMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult)
    {
        let data = call.arguments as? [String: Any] ?? [String: Any]()

        if #available(iOS 16.1, *) {
            switch call.method {
            case "startLiveActivity":
                LiveActivitiesController.startLiveActivity(result: result, data: data)
                break
            case "updateLiveActivity":
                LiveActivitiesController.updateLiveActivity(result: result, data: data)
                break
            case "endLiveActivity":
                LiveActivitiesController.endLiveActivity(result: result, data: data)
                break
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
    
    private static func startLiveActivity(result: @escaping FlutterResult, data: [String: Any]) {
        
    }
    
    private static func updateLiveActivity(result: @escaping FlutterResult, data: [String: Any]) {
        
    }
    
    private static func endLiveActivity(result: @escaping FlutterResult, data: [String: Any]) {
        
    }
}
