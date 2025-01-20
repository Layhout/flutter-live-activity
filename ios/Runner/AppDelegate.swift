import Flutter
import UIKit
import ActivityKit
import Foundation

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        LiveActivitiesManager.register(controller: controller)
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
