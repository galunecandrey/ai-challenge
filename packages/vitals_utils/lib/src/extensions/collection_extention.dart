import 'dart:math';

extension NullableListExt<T> on List<T>? {
  List<T> get orEmpty => this ?? [];
}

extension ListExt<T> on List<T> {
  List<T> copy([T Function(T)? copyElement]) => copyElement == null ? List.from(this) : map(copyElement).toList();

  List<T> ifEmpty(List<T> defaultValue) => orEmpty.isEmpty ? defaultValue : this;

  T? Function(bool Function(T element) predicate) get find => firstOrNull;

  T? Function(bool Function(T element) predicate) get findLast => lastOrNull;

  T get(int index) => this[index];

  T? get firstNullable => getOrNull(0);

  T getOrElse(int index, T Function(int) defaultValue) =>
      index >= 0 && index <= lastIndex ? this[index] : defaultValue(index);

  T? getOrNull(int index) => index >= 0 && index <= lastIndex ? this[index] : null;

  T getOrDefault(
    int index, {
    required T defaultValue,
  }) =>
      index >= 0 && index <= lastIndex ? this[index] : defaultValue;

  T get e1 => this[0];

  T get e2 => this[1];

  T get e3 => this[2];

  T get e4 => this[3];

  T get e5 => this[4];

  T? firstOrNull(bool Function(T) where) {
    for (final element in this) {
      if (where(element)) {
        return element;
      }
    }
    return null;
  }

  T? lastOrNull(bool Function(T) where) {
    late T result;
    var foundMatching = false;
    for (final element in this) {
      if (where(element)) {
        result = element;
        foundMatching = true;
      }
    }
    if (foundMatching) {
      return result;
    }
    return null;
  }

  void sortBy<R>(Comparable<R> Function(T) selector) => sort(
        (a, b) => Comparable.compare(
          selector(a),
          selector(b),
        ),
      );

  void sortByDescending<R>(Comparable<R> Function(T) selector) => sort(
        (a, b) => Comparable.compare(
          selector(b),
          selector(a),
        ),
      );

  List<T> sorted([int Function(T a, T b)? compare]) => copy()..sort(compare);

  List<T> sortedDescending([int Function(T a, T b)? compare]) => (copy()..sort(compare)).reversed.toList();

  List<T> sortedBy<R>(Comparable<R> Function(T) selector) =>
      copy()..sort((a, b) => Comparable.compare(selector(a), selector(b)));

  List<T> sortedByDescending<R>(Comparable<R> Function(T) selector) =>
      copy()..sort((a, b) => Comparable.compare(selector(b), selector(a)));

  T random() {
    if (isEmpty) {
      throw Exception('Collection is empty.');
    }
    return this[Random().nextInt(length)];
  }

  T? randomOrNull() {
    if (isEmpty) {
      return null;
    }
    return this[Random().nextInt(length)];
  }

  T randomOrDefault(T defaultValue) {
    if (isEmpty) {
      return defaultValue;
    }
    return this[Random().nextInt(length)];
  }

  T randomOrElse(T Function() orElse) {
    if (isEmpty) {
      return orElse();
    }
    return this[Random().nextInt(length)];
  }

  List<T> filter(bool Function(T element) predicate) => where(predicate).toList();

  List<T> filterIndexed(bool Function(int index, T element) predicate) {
    var index = 0;
    final newList = <T>[];
    for (final item in this) {
      if (predicate(index, item)) {
        newList.add(item);
      }
      index++;
    }
    return newList;
  }

  List<T> filterNot(bool Function(T element) predicate) => where((e) => !predicate(e)).toList();

  List<T> filterNotNull() => where((e) => e != null).toList();

  List<T> takeLast(int count) {
    assert(count >= 0);
    if (count >= length) {
      return this;
    }
    if (count == 1) {
      return [last];
    }
    return toList().sublist(length - count, length);
  }

  List<T> takeLastWhile(bool Function(T element) predicate) {
    final currentList = toList();
    final list = toList();
    for (var i = currentList.length - 1; predicate(currentList[i]); i--) {
      list.add(currentList[i]);
    }
    return list;
  }

  List<R> mapIndexed<R>(R Function(int index, T element) predicate) {
    var index = 0;
    final newList = <R>[];
    for (final item in this) {
      newList.add(predicate(index, item));
      index++;
    }
    return newList;
  }

  List<T> distinct() => toSet().toList();

  List<T> distinctBy<K>(K Function(T) selector) {
    final set = <K>{};
    final list = <T>[];
    for (final e in this) {
      final key = selector(e);
      if (set.add(key)) {
        list.add(e);
      }
    }
    return list;
  }

  List<T> onEach(void Function(T) action) {
    for (final item in this) {
      action(item);
    }
    return this;
  }

  int get lastIndex => length - 1;
}

extension IterableExt<T> on Iterable<T> {
  bool containsAll(Iterable<T> list) {
    for (final item in list) {
      if (!contains(item)) {
        return false;
      }
    }
    return true;
  }

  T elementAtOrElse(int index, T Function(int) defaultValue) {
    if (this is List<T>) {
      return ListExt(this as List<T>).getOrElse(index, defaultValue);
    }
    if (index < 0) {
      return defaultValue(index);
    }
    var elementIndex = 0;
    for (final element in this) {
      if (index == elementIndex) {
        return element;
      }
      elementIndex++;
    }
    return defaultValue(index);
  }

  T elementAtOrDefault(int index, T defaultValue) {
    if (this is List<T>) {
      return ListExt(this as List<T>).getOrDefault(index, defaultValue: defaultValue);
    }
    if (index < 0) {
      return defaultValue;
    }
    var elementIndex = 0;
    for (final element in this) {
      if (index == elementIndex) {
        return element;
      }
      elementIndex++;
    }
    return defaultValue;
  }

  T? elementAtOrNull(int index) {
    if (this is List<T>) {
      return ListExt(this as List<T>).getOrNull(index);
    }
    if (index < 0) {
      return null;
    }
    var elementIndex = 0;
    for (final element in this) {
      if (index == elementIndex) {
        return element;
      }
      elementIndex++;
    }
    return null;
  }

  int indexOfFirst(bool Function(T element) predicate) {
    var index = 0;
    for (final item in this) {
      if (predicate(item)) {
        return index;
      }
      index++;
    }
    return -1;
  }

  int indexOfLast(bool Function(T element) predicate) {
    var lastIndex = -1;
    var index = 0;
    for (final item in this) {
      if (predicate(item)) {
        lastIndex = index;
      }
      index++;
    }
    return lastIndex;
  }

  Set<T> intersect(Iterable<T> other) {
    final set = toSet()..retainAll(other);
    return set;
  }

  Set<T> subtract(Iterable<T> other) {
    final set = toSet()..removeAll(other);
    return set;
  }

  Set<T> union(Iterable<T> other) {
    final set = toSet()..addAll(other);
    return set;
  }

  bool Function(bool Function(T)) get all => every;

  bool none(bool Function(T) predicate) => !any(predicate);

  R fold<R>(R initial, R Function(R, T) operation) {
    var accumulator = initial;
    for (final element in this) {
      accumulator = operation(accumulator, element);
    }
    return accumulator;
  }

  R foldIndexed<R>(R initial, R Function(int index, R, T) operation) {
    var index = 0;
    var accumulator = initial;
    for (final element in this) {
      accumulator = operation(index++, accumulator, element);
    }
    return accumulator;
  }

  void forEachIndexed(void Function(int, T) action) {
    var index = 0;
    for (final item in this) {
      action(index++, item);
    }
  }

  T? maxBy<R extends num>(R Function(T) selector) {
    T? max;
    for (final e in this) {
      max = max == null || selector(max) < selector(e) ? e : max;
    }
    return max;
  }

  T? minBy<R extends num>(R Function(T) selector) {
    T? min;
    for (final e in this) {
      min = min == null || selector(min) > selector(e) ? e : min;
    }
    return min;
  }

  T? maxWith<R extends num>(Comparator<T> comparator) {
    T? max;
    for (final e in this) {
      max = max == null || comparator(max, e) < 0 ? e : max;
    }
    return max;
  }

  T? minWith<R extends num>(Comparator<T> comparator) {
    T? min;
    for (final e in this) {
      min = min == null || comparator(min, e) > 0 ? e : min;
    }
    return min;
  }

  T reduceIndexed(T Function(int index, T value, T element) combine) {
    final iterator = this.iterator;
    if (!iterator.moveNext()) {
      throw StateError('No element');
    }
    var value = iterator.current;
    var index = 1;
    while (iterator.moveNext()) {
      value = combine(index++, value, iterator.current);
    }
    return value;
  }

  T? reduceOrNull(T Function(T value, T element) combine) {
    final iterator = this.iterator;
    if (!iterator.moveNext()) {
      return null;
    }
    var value = iterator.current;
    while (iterator.moveNext()) {
      value = combine(value, iterator.current);
    }
    return value;
  }

  List<R> scan<R>(R initial, R Function(R, T) operation) {
    if (length == 0) {
      return [initial];
    }
    final result = <R>[];
    var accumulator = initial;
    for (final e in this) {
      accumulator = operation(accumulator, e);
      result.add(accumulator);
    }
    return result;
  }

  List<R> scanIndexed<R>(R initial, R Function(int index, R, T) operation) {
    if (length == 0) {
      return [initial];
    }
    final result = <R>[];
    var accumulator = initial;
    var index = 0;
    for (final e in this) {
      accumulator = operation(index++, accumulator, e);
      result.add(accumulator);
    }
    return result;
  }

  List<T> scanReduce(T Function(T, T) operation) {
    final iterator = this.iterator;
    if (!iterator.moveNext()) {
      return [];
    }
    var accumulator = iterator.current;
    final result = <T>[];
    while (iterator.moveNext()) {
      accumulator = operation(
        accumulator,
        iterator.current,
      );
      result.add(accumulator);
    }
    return result;
  }

  List<T> scanReduceIndexed(T Function(int, T, T) operation) {
    final iterator = this.iterator;
    if (!iterator.moveNext()) {
      return [];
    }
    var accumulator = iterator.current;
    final result = <T>[];
    var index = 1;
    while (iterator.moveNext()) {
      accumulator = operation(
        index++,
        accumulator,
        iterator.current,
      );
      result.add(accumulator);
    }
    return result;
  }

  int sumBy(int Function(T) selector) {
    var sum = 0;
    for (final e in this) {
      sum += selector(e);
    }
    return sum;
  }

  double sumByDouble(double Function(T) selector) {
    var sum = 0.0;
    for (final e in this) {
      sum += selector(e);
    }
    return sum;
  }

  List<V> zip<R, V>(Iterable<R> other, V Function(T, R) transform) {
    final result = <V>[];
    final first = iterator;
    final second = other.iterator;
    while (first.moveNext() && second.moveNext()) {
      result.add(transform(first.current, second.current));
    }
    return result;
  }

  List<R> zipWithNext<R>(R Function(T, T) transform) {
    final result = <R>[];
    final first = iterator;
    if (!first.moveNext()) {
      return result;
    }
    var current = first.current;
    while (first.moveNext()) {
      result.add(transform(current, first.current));
      current = first.current;
    }
    return result;
  }
}

extension IterableNumExt<T extends num> on Iterable<T> {
  T? max() {
    T? max;
    for (final e in this) {
      max = max == null || max < e ? e : max;
    }
    return max;
  }

  T? min() {
    T? min;
    for (final e in this) {
      min = min == null || min > e ? e : min;
    }
    return min;
  }
}
