import 'package:flutter/material.dart';

abstract class LifecycleEventsProvider {
  Stream<AppLifecycleState> get appLifecycleState;

  void dispose();
}
