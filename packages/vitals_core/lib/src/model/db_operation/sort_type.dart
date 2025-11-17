enum SortType {
  asc('ASC'),
  desc('DESC');

  final String value;

  const SortType(this.value);

  @override
  String toString() => value;
}
