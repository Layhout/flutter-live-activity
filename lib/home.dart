import 'dart:async';

import 'package:fal/live_activity_manager.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();

    LiveActivityManager.init('my.method.channel');
  }

  void _testUpdateLiveActivity() async {
    await LiveActivityManager.startLiveActivity(data: {
      'title': 'Placed',
      'description': 'Your order has been placed',
      'step': 0,
      'distance': 3,
    });

    await Future.delayed(const Duration(seconds: 5));

    await LiveActivityManager.updateLiveActivity(data: {
      'title': 'Preparing',
      'description': 'We are preparing your order',
      'step': 1,
      'distance': 3,
    });

    await Future.delayed(const Duration(seconds: 5));

    await LiveActivityManager.updateLiveActivity(data: {
      'title': 'Delivering',
      'description': 'We are delivering your order',
      'step': 2,
      'distance': 3,
    });

    await Future.delayed(const Duration(seconds: 5));

    await LiveActivityManager.updateLiveActivity(data: {
      'title': 'Completed',
      'description': 'All Done! 👌',
      'step': 3,
      'distance': 3,
    });

    await Future.delayed(const Duration(seconds: 5));

    await LiveActivityManager.endLiveActivity();
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
                "Testing Live Activity",
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                "Press \"Simulate Place an Order,\" swipe down, and view the live activity on your lock screen.",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _testUpdateLiveActivity,
                  child: const Text('Simulate place an order'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
