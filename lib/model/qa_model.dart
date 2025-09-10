import 'dart:core';

class QA {
  final String q;
  final String a;
  final List<Tag> tags;

  const QA({required this.q, required this.a, this.tags = const []});
}

enum Tag { git, oop, complexity, dart, future, stream, memory, flutter, isolate }
