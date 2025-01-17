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
    private static var managerChannel: FlutterMethodChannel? = nil
    private static var activity: Activity<MyNativeWidgetAttributes>? = nil
    
    public static func register(controller: FlutterViewController) {
        managerChannel = FlutterMethodChannel(
            name: "my.method.channel",
            binaryMessenger: controller.binaryMessenger
        )
        managerChannel?.setMethodCallHandler(handleMethodCall)
    }
    
    static func handleMethodCall(call: FlutterMethodCall, result: FlutterResult) {
        var data = call.arguments as? Dictionary<String,Any> ?? [String: Any]()
        
        switch call.method {
        case "startLiveActivity":
            LiveActivitiesManager.startLiveActivity(data: data, result: result)
            break
        case "updateLiveActivity":
            LiveActivitiesManager.updateLiveActivity(data: data, result: result)
            break
        case "endLiveActivity":
            LiveActivitiesManager.endLiveActivity(data: data, result: result)
            break
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    static func startLiveActivity(data: [String: Any], result: FlutterResult) {
        if #unavailable(iOS 16.1) {
            result(FlutterError(code: "1", message: "Live activity supported on 16.1 and higher", details: nil))
        }
        
        let endTime: Date = Date(timeIntervalSince1970: Double(data["endTime"] as? Int ?? 1000) / 1000)
        
        let attributes = MyNativeWidgetAttributes()
        let state = MyNativeWidgetAttributes.ContentState(
            endTime: endTime
        )
        
        if #available(iOS 16.1, *) {
            do {
                activity = try Activity<MyNativeWidgetAttributes>.request(
                    attributes: attributes,
                    content: .init(state: state, staleDate: nil),
                    pushType: nil)
                
                result("Success")
            } catch let error {
                result(FlutterError(code: "2", message: "Error requesting live activity", details: nil))
            }
        }
    }
    
    static func updateLiveActivity(data: [String: Any], result: FlutterResult) {
        if #unavailable(iOS 16.1) {
            result(FlutterError(code: "1", message: "Live activity supported on 16.1 and higher", details: nil))
        }
        
        if #available(iOS 16.1, *) {
            Task {
                let state = MyNativeWidgetAttributes.ContentState()
                
                await activity?.update(ActivityContent<MyNativeWidgetAttributes.ContentState>(state: state, staleDate: nil))
            }
            
            result("Success")
        }
    }
    
    static func endLiveActivity(data: [String: Any], result: FlutterResult) {
        if #unavailable(iOS 16.1) {
            result(FlutterError(code: "1", message: "Live activity supported on 16.1 and higher", details: nil))
        }
        
        if #available(iOS 16.1, *) {
            Task {
                await activity?.end(nil, dismissalPolicy: .after(Calendar.current.date(byAdding: .second, value: 5, to: Date())!))
            }
            
            result("Success")
        }
    }
}
