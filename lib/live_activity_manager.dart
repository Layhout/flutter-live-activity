import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum LiveActivityAction {
  startLiveActivity,
  updateLiveActivity,
  endLiveActivity;
}

class StartLiveActivityResponse {
  final String? id;
  final String? pushToken;

  StartLiveActivityResponse({required this.id, required this.pushToken});

  factory StartLiveActivityResponse.fromDynamicMap(Map<dynamic, dynamic> map) {
    return StartLiveActivityResponse(
      id: map['id'],
      pushToken: map['pushToken'],
    );
  }
}

class LiveActivityManager {
  LiveActivityManager._();

  static bool _isInitialized = false;
  static late MethodChannel _platform;
  static bool get _isAuthorizedCall {
    if (!_isInitialized) {
      debugPrint('LiveActivityManager is not initialized');
    }

    return _isInitialized;
  }

  static int? _getTimeInMinutes(Duration? staleInMinutes) =>
      (staleInMinutes?.inMinutes ?? 0) >= 1 ? staleInMinutes?.inMinutes : null;
  static int? _getTimeInSeconds(Duration? staleInMinutes) =>
      (staleInMinutes?.inSeconds ?? 0) >= 1 ? staleInMinutes?.inMinutes : null;

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

  static Future<StartLiveActivityResponse?> startLiveActivity(
      {Map<String, dynamic>? data, Duration? staleInMinutes}) async {
    if (!_isAuthorizedCall) {
      return null;
    }

    try {
      dynamic result = await _platform.invokeMethod(
        LiveActivityAction.startLiveActivity.name,
        {...(data ?? {}), "staleInMinutes": _getTimeInMinutes(staleInMinutes)},
      );

      return StartLiveActivityResponse.fromDynamicMap(result);
    } catch (e) {
      debugPrint('Failed to start LiveActivity: $e');
      return null;
    }
  }

  static Future<void> updateLiveActivity(
      {Map<String, dynamic>? data, Duration? staleInMinutes}) async {
    if (!_isAuthorizedCall) {
      return;
    }

    try {
      await _platform.invokeMethod(
        LiveActivityAction.updateLiveActivity.name,
        {...(data ?? {}), "staleInMinutes": _getTimeInMinutes(staleInMinutes)},
      );
    } catch (e) {
      debugPrint('Failed to update LiveActivity: $e');
    }
  }

  static Future<void> endLiveActivity(
      {Map<String, dynamic>? data,
      Duration? staleInMinutes,
      Duration? endInSecond}) async {
    if (!_isAuthorizedCall) {
      return;
    }

    try {
      await _platform.invokeMethod(
        LiveActivityAction.endLiveActivity.name,
        {
          ...(data ?? {}),
          "staleInMinutes": _getTimeInMinutes(staleInMinutes),
          "endInSecond": _getTimeInSeconds(endInSecond),
        },
      );
    } catch (e) {
      debugPrint('Failed to end LiveActivity: $e');
    }
  }
}
