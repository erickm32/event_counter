import 'package:event_counter/models/event.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.question_mark),
            title: Text(event.name),
            subtitle: Text(event.category),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                child: const Text('Edit'),
                onPressed: () {/* ... */},
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}
