import 'dart:async';

import 'package:fal/live_activity_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _started = false;
  Duration _timeLeft = Duration.zero;
  Duration _pickedTime = Duration.zero;
  DateTime _endTime = DateTime.now();
  Timer? _timerId;

  @override
  void initState() {
    super.initState();

    LiveActivityManager.init('my.method.channel');
  }

  @override
  void dispose() {
    _timerId?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (_started) {
      setState(
        () {
          _started = false;
          _timerId?.cancel();
        },
      );

      LiveActivityManager.endLiveActivity();

      return;
    }

    setState(() {
      _endTime =
          DateTime.now().add(const Duration(seconds: 1)).add(_pickedTime);
      _timeLeft = _endTime.difference(DateTime.now());
      _started = true;
    });

    LiveActivityManager.startLiveActivity(
      data: {
        'endTime': _endTime.millisecondsSinceEpoch,
      },
    );

    _timerId = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        setState(
          () {
            _timeLeft = _endTime.difference(DateTime.now());
            if (_timeLeft.inSeconds <= 0) {
              _timerId?.cancel();
              _pickedTime = Duration.zero;
              _started = false;
              LiveActivityManager.endLiveActivity();
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Simple Timer",
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(
                height: 16,
              ),
              if (!_started)
                SizedBox(
                  height: 150,
                  child: CupertinoTimerPicker(
                    mode: CupertinoTimerPickerMode.ms,
                    onTimerDurationChanged: (value) {
                      _pickedTime = value;
                    },
                  ),
                )
              else
                Text(
                  "${_timeLeft.inMinutes.toString().padLeft(2, '0')}:${_timeLeft.inSeconds.remainder(60).toString().padLeft(2, '0')}",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _startTimer,
                  child: Text(_started ? 'Stop' : 'Start'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
