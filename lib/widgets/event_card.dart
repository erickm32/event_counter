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
            leading: iconForCategory(),
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

  Icon iconForCategory() {
    switch (event.category) {
      case 'Saúde':
        return const Icon(Icons.health_and_safety);
      case 'Estudo':
        return const Icon(Icons.menu_book);
      case 'Trabalho':
        return const Icon(Icons.work);
      case 'Lazer':
        return const Icon(Icons.sports_esports_outlined);
      case 'Rotina Diária':
        return const Icon(Icons.task_alt);
      default:
        return const Icon(Icons.library_books_outlined);
    }
  }
}
