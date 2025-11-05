//ignore_for_file: close_sinks
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:vitals_core/src/api/providers/lifecycle_events_provider.dart';
import 'package:vitals_utils/vitals_utils.dart';

@LazySingleton(as: LifecycleEventsProvider)
class DefaultLifecycleEventsProviderImpl extends Disposable implements LifecycleEventsProvider {
  late final _lifecycleState = stateOf<AppLifecycleState>(AppLifecycleState.resumed);
  late final AppLifecycleListener _listener;

  DefaultLifecycleEventsProviderImpl() {
    _listener = AppLifecycleListener(
      onStateChange: _didChangeAppLifecycleState,
    );
  }

  @override
  Stream<AppLifecycleState> get appLifecycleState => _lifecycleState.stream;

  void _didChangeAppLifecycleState(AppLifecycleState state) {
    _lifecycleState.add(state);
  }

  @disposeMethod
  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }
}
