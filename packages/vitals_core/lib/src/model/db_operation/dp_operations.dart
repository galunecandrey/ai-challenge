import 'package:flutter/cupertino.dart';
import 'package:vitals_core/src/model/db_operation/sort_type.dart' show SortType;

sealed class DBOperation {
  factory DBOperation.sort({
    required String fieldName,
    required SortType sortType,
  }) =>
      Sort(
        fieldName: fieldName,
        sortType: sortType,
      );

  factory DBOperation.sortMultiple({
    required String fieldName1,
    required SortType sortType1,
    required String fieldName2,
    required SortType sortType2,
  }) =>
      Sort.multiple(
        fieldName1: fieldName1,
        sortType1: sortType1,
        fieldName2: fieldName2,
        sortType2: sortType2,
      );

  factory DBOperation.limit(int count) => Limit(count);

  factory DBOperation.distinct(String fieldName) => Distinct(fieldName);

  factory DBOperation.distinctMultiple(
    String fieldName1,
    String fieldName2,
  ) =>
      Distinct.multiple(fieldName1, fieldName2);
}

@immutable
final class Sort implements DBOperation {
  final String _fieldName1;
  final SortType _sortType1;
  final String? _fieldName2;
  final SortType? _sortType2;

  const Sort({
    required String fieldName,
    required SortType sortType,
  })  : _fieldName1 = fieldName,
        _fieldName2 = null,
        _sortType1 = sortType,
        _sortType2 = null;

  const Sort.multiple({
    required String fieldName1,
    required SortType sortType1,
    required String fieldName2,
    required SortType sortType2,
  })  : _fieldName1 = fieldName1,
        _fieldName2 = fieldName2,
        _sortType1 = sortType1,
        _sortType2 = sortType2;

  @override
  String toString() => 'SORT($_fieldName1 $_sortType1'
      '${_fieldName2 != null ? ', $_fieldName2 ${_sortType2 ?? SortType.asc}' : ''}'
      ')';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Sort &&
          runtimeType == other.runtimeType &&
          _fieldName1 == other._fieldName1 &&
          _sortType1 == other._sortType1 &&
          _fieldName2 == other._fieldName2 &&
          _sortType2 == other._sortType2;

  @override
  int get hashCode => _fieldName1.hashCode ^ _sortType1.hashCode ^ _fieldName2.hashCode ^ _sortType2.hashCode;
}

@immutable
final class Limit implements DBOperation {
  final int count;

  const Limit(this.count);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Limit && runtimeType == other.runtimeType && count == other.count;

  @override
  int get hashCode => count.hashCode;

  @override
  String toString() => 'LIMIT($count)';
}

@immutable
final class Distinct implements DBOperation {
  final String _fieldName1;
  final String? _fieldName2;

  const Distinct(String fieldName)
      : _fieldName1 = fieldName,
        _fieldName2 = null;

  const Distinct.multiple(
    String fieldName1,
    String fieldName2,
  )   : _fieldName1 = fieldName1,
        _fieldName2 = fieldName2;

  @override
  String toString() => 'DISTINCT($_fieldName1'
      '${_fieldName2 != null ? ', $_fieldName2' : ''}'
      ')';
}
