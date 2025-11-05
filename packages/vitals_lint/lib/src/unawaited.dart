void unawaited(Future<dynamic>? future) {}

extension UnawaitedExt on Future<dynamic>?{
  void get noWait => unawaited(this);
}
