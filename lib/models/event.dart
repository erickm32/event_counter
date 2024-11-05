class Event {
  const Event(
      {required this.name,
      required this.category,
      required this.timestamp,
      this.observation});

  final String name;
  final String category;
  final DateTime timestamp;
  final String? observation;

  @override
  String toString() {
    return "Event $name, $category";
  }
}
