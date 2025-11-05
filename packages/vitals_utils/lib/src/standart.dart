extension StandartExt<T> on T {
  A let<A>(A Function(T) block) => block(this);

  T also(void Function(T) block) {
    block(this);
    return this;
  }
}

extension StandartNullExt<T> on T? {
  bool get isNull => this == null;

  bool get isNotNull => this != null;

  T orDefault(T def) => this ?? def;
}
