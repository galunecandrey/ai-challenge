import 'dart:async';

class CompositeCancelable {
  late final _subscriptions = <StreamSubscription<dynamic>>{};
  late final _keySubscriptions = <Object, StreamSubscription<dynamic>>{};

  void add(StreamSubscription<dynamic> subscription) {
    _subscriptions.add(subscription);
  }

  CompositeCancelable operator +(StreamSubscription<dynamic> subscription) {
    add(subscription);
    return this;
  }

  void operator []=(Object key, StreamSubscription<dynamic> subscription) {
    addKey(key, subscription);
  }

  StreamSubscription<dynamic>? operator [](Object key) => _keySubscriptions[key];

  void addAll(List<StreamSubscription<dynamic>> subscriptions) {
    _subscriptions.addAll(subscriptions);
  }

  bool removeKey(Object key, {bool cancel = true}) {
    final subscription = _keySubscriptions.remove(key);
    final result = subscription != null;
    if (result && cancel) {
      subscription.cancel();
    }
    return result;
  }

  bool remove(StreamSubscription<dynamic> subscription, {bool cancel = true}) {
    final result = _subscriptions.remove(subscription);
    if (cancel) {
      subscription.cancel();
    }
    return result;
  }

  void addKey(
    Object key,
    StreamSubscription<dynamic> subscription, {
    bool addIfNotEmpty = true,
    bool cancelIfNotEmpty = true,
  }) {
    final previous = _keySubscriptions[key];
    if (previous != null) {
      if (!addIfNotEmpty) {
        return;
      }
      if (cancelIfNotEmpty) {
        previous.cancel();
      }
    }
    _keySubscriptions[key] = subscription;
  }

  int get size => _subscriptions.length + _keySubscriptions.length;

  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
    for (final subscription in _keySubscriptions.values) {
      subscription.cancel();
    }
    _keySubscriptions.clear();
  }

  Future<void> asyncDispose() async {
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    _subscriptions.clear();
    for (final key in _keySubscriptions.keys) {
      await _keySubscriptions[key]?.cancel();
    }
    _keySubscriptions.clear();
  }
}

class CompositeCloseable {
  final _controllers = <StreamController<dynamic>>[];
  final _keyControllers = <Object, StreamController<dynamic>>{};

  T add<T extends StreamController<dynamic>>(T controller) {
    _controllers.add(controller);
    return controller;
  }

  CompositeCloseable operator +(StreamController<dynamic> controller) {
    add(controller);
    return this;
  }

  void operator []=(Object key, StreamController<dynamic> controller) {
    addKey(key, controller);
  }

  StreamController<dynamic>? operator [](Object key) => _keyControllers[key];

  T? getKey<T extends StreamController<dynamic>>(Object key) => _keyControllers[key] as T?;

  T? get<T extends StreamController<dynamic>>(int index) => _controllers[index] as T?;

  void addAll(List<StreamController<dynamic>> controllers) {
    _controllers.addAll(controllers);
  }

  bool removeKey(Object key, {bool cancel = true}) {
    final controller = _keyControllers.remove(key);
    final result = controller != null;
    if (result && cancel) {
      controller.close();
    }
    return result;
  }

  bool remove(StreamController<dynamic> controller, {bool cancel = true}) {
    final result = _controllers.remove(controller);
    if (cancel) {
      controller.close();
    }
    return result;
  }

  void addKey(
    Object key,
    StreamController<dynamic> controller, {
    bool addIfNotEmpty = true,
    bool cancelIfNotEmpty = true,
  }) {
    final previous = _keyControllers[key];
    if (previous != null) {
      if (!addIfNotEmpty) {
        return;
      }
      if (cancelIfNotEmpty) {
        previous.close();
      }
    }
    _keyControllers[key] = controller;
  }

  int get size => _controllers.length + _keyControllers.length;

  void dispose() {
    for (final controller in _controllers) {
      controller.close();
    }
    _controllers.clear();
    for (final controller in _keyControllers.values) {
      controller.close();
    }
    _keyControllers.clear();
  }

  Future<void> asyncDispose() async {
    for (final controller in _controllers) {
      await controller.close();
    }
    _controllers.clear();
    for (final value in _keyControllers.values) {
      await value.close();
    }
    _keyControllers.clear();
  }
}

mixin CancelableMixin {
  late final cancelable = CompositeCancelable();
}

mixin CloseableMixin {
  late final closeable = CompositeCloseable();
}

extension StreamSubscriptionExt<T> on StreamSubscription<T> {
  StreamSubscription<T> cancelable(
    CompositeCancelable cc, {
    String? key,
  }) {
    if (key == null) {
      cc.add(this);
    } else {
      cc.addKey(key, this);
    }
    return this;
  }
}

extension StreamControllerExt<T, C extends StreamController<T>> on C {
  C closeable(
    CompositeCloseable cc, {
    String? key,
  }) {
    if (key == null) {
      cc.add(this);
    } else {
      cc.addKey(key, this);
    }
    return this;
  }
}
