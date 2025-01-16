import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum LiveActivityAction {
  startLiveActivity,
  updateLiveActivity,
  endLiveActivity;
}

class LiveActivityManager {
  LiveActivityManager._();

  static bool _isInitialized = false;
  static late MethodChannel _platform;
  static bool get _authorizedCall {
    if (!_isInitialized) {
      debugPrint('LiveActivityManager is not initialized');
    }

    return _isInitialized;
  }

  static Future<void> init(String channelName) async {
    if (_isInitialized) return;

    try {
      _platform = MethodChannel(channelName);
    } catch (e) {
      debugPrint('Failed to initialize LiveActivityManager: $e');
    } finally {
      _isInitialized = true;
    }
  }

  static Future<void> startLiveActivity({Map<String, dynamic>? data}) async {
    if (!_authorizedCall) {
      return;
    }

    try {
      await _platform.invokeMethod(
        LiveActivityAction.startLiveActivity.name,
        data,
      );
    } catch (e) {
      debugPrint('Failed to start LiveActivity: $e');
    }
  }

  static Future<void> updateLiveActivity({Map<String, dynamic>? data}) async {
    if (!_authorizedCall) {
      return;
    }

    try {
      await _platform.invokeMethod(
        LiveActivityAction.updateLiveActivity.name,
        data,
      );
    } catch (e) {
      debugPrint('Failed to update LiveActivity: $e');
    }
  }

  static Future<void> endLiveActivity({Map<String, dynamic>? data}) async {
    if (!_authorizedCall) {
      return;
    }

    try {
      await _platform.invokeMethod(
        LiveActivityAction.endLiveActivity.name,
        data,
      );
    } catch (e) {
      debugPrint('Failed to end LiveActivity: $e');
    }
  }
}
