class Something {
  final String name;
  final bool isClosed;

  const Something({this.name, this.isClosed = false});

  @override
  String toString() {
    return 'Place $name (closed : $isClosed)';
  }
}