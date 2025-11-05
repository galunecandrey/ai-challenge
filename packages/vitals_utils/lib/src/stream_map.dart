import 'package:vitals_utils/src/stream_object.dart';

class StreamMap<K, V> extends StreamObject<Map<K, V>> implements Map<K, V> {
  StreamMap([Map<K, V>? initValue]) : super(Map<K, V>.unmodifiable(initValue ?? <K, V>{}));

  @override
  V? operator [](Object? key) => state[key];

  @override
  void operator []=(K key, V value) {
    state = Map<K, V>.unmodifiable(<K, V>{
      ...state,
      key: value,
    });
  }

  @override
  void addAll(Map<K, V> other) {
    state = Map<K, V>.unmodifiable(<K, V>{
      ...state,
      ...other,
    });
  }

  @override
  void addEntries(Iterable<MapEntry<K, V>> newEntries) {
    state = Map<K, V>.unmodifiable(<K, V>{
      ...state,
      for (final e in entries) e.key: e.value,
    });
  }

  @override
  Map<RK, RV> cast<RK, RV>() => Map.from(state);

  @override
  void clear() {
    state = Map<K, V>.unmodifiable(<K, V>{});
  }

  @override
  bool containsKey(Object? key) => state.containsKey(key);

  @override
  bool containsValue(Object? value) => state.containsValue(value);

  @override
  Iterable<MapEntry<K, V>> get entries => state.entries;

  @override
  void forEach(void Function(K key, V value) action) => state.forEach(action);

  @override
  bool get isEmpty => state.isEmpty;

  @override
  bool get isNotEmpty => state.isNotEmpty;

  @override
  Iterable<K> get keys => state.keys;

  @override
  int get length => state.length;

  @override
  Map<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(K key, V value) convert) => state.map(convert);

  @override
  V putIfAbsent(K key, V Function() ifAbsent) {
    if (containsKey(key)) {
      return state[key]!;
    } else {
      final result = ifAbsent();
      state = Map<K, V>.unmodifiable(<K, V>{
        ...state,
        key: result,
      });
      return result;
    }
  }

  @override
  V? remove(Object? key) {
    if (containsKey(key)) {
      final oldMap = Map.of(state);
      final result = oldMap.remove(key);
      state = Map<K, V>.unmodifiable(oldMap);
      return result;
    }
    return null;
  }

  @override
  void removeWhere(bool Function(K key, V value) test) {
    state = Map<K, V>.unmodifiable(Map<K, V>.of(state)..removeWhere(test));
  }

  @override
  V update(K key, V Function(V value) update, {V Function()? ifAbsent}) {
    final oldMap = Map.of(state);
    final result = oldMap.update(key, update, ifAbsent: ifAbsent);
    state = Map<K, V>.unmodifiable(oldMap);
    return result;
  }

  @override
  void updateAll(V Function(K key, V value) update) {
    state = Map<K, V>.unmodifiable(Map<K, V>.of(state)..updateAll(update));
  }

  void replaceAll(Map<K, V> other) {
    state = Map<K, V>.unmodifiable(<K, V>{...other});
  }

  @override
  Iterable<V> get values => state.values;
}
