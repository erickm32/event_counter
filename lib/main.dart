import 'dart:convert';

import 'package:event_counter/models/category.dart';
import 'package:event_counter/pages/category_form.dart';
import 'package:event_counter/pages/event_form.dart';
import 'package:event_counter/widgets/event_card.dart';
import 'package:event_counter/widgets/event_stats_card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'models/event.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        // 'new_event': (context) => const EventForm(),
        'new_category': (context) => const CategoryFormPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Event> eventsList = [];
  List<Category> categoriesList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // Fetch data from a sample JSON API
  Future<void> fetchData() async {
    final events =
        await http.get(Uri.parse('http://10.0.2.2:5000/api/events.json'));
    final categories =
        await http.get(Uri.parse('http://10.0.2.2:5000/api/categories.json'));

    if (events.statusCode == 200 && events.statusCode == 200) {
      setState(() {
        List<dynamic> temp = json.decode(events.body);
        for (var element in temp) {
          eventsList.add(Event(
            category: element['category_id'].toString(),
            name: element['name'],
            timestamp: DateTime.parse(element['created_at']),
          ));
        }
        temp = json.decode(categories.body);
        for (var element in temp) {
          categoriesList.add(Category(
            name: element['name'].toString(),
            serverId: element['id'],
          ));
        }
        eventsList.insert(
            0, Event(category: '', name: '', timestamp: DateTime.now()));
        // isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    print(eventsList);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        // leading: IconButton(
        //   icon: Icon(Icons.menu),
        //   onPressed: () {},
        // ),
      ),
      body: ListView.builder(
        itemCount: eventsList.length,
        itemBuilder: (context, index) {
          if (index == 0) {
            return const EventStatsCard();
          } else {
            return EventCard(
              event: eventsList[index],
            );
          }
        },
      ),
      drawer: Drawer(
        child: ListView(children: const [
          DrawerHeader(child: Text('header')),
          ListTile(
            title: Text('listtile title'),
          ),
          ListTile(
            title: Text('anotherlisttile title'),
          )
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          showModalBottomSheet(
              context: context,
              showDragHandle: true,
              builder: (buildContext) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (c) => const CategoryFormPage()),
                          ).then((value) => setState(
                                () => categoriesList.add(value),
                              ));
                        },
                        child: const Text('Criar nova categoria'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (c) => EventForm(
                                categories: categoriesList,
                              ),
                            ),
                          ).then(
                              (value) => setState(() => eventsList.add(value)));
                        },
                        child: const Text('Registrar novo evento'),
                      ),
                    ],
                  ),
                );
              })
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
