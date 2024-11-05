import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:event_counter/models/category.dart';
import 'package:event_counter/models/event.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EventForm extends StatefulWidget {
  final List<Category> categories;

  const EventForm({super.key, required this.categories});

  @override
  State<EventForm> createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final categoryController = TextEditingController();

  Category? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Event'),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListView(
        children: [
          Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  TextFormField(
                      decoration:
                          const InputDecoration(label: Text("Event Name")),
                      controller: nameController,
                      validator: (value) {
                        print(value);
                        return value == null || value == '' ? 'required' : null;
                      }),
                  DropdownSearch<Category>(
                    items: widget.categories
                    // .map((e) => (e.name, e.serverId))
                    // .toList(),
                    ,
                    compareFn: (Category item1, Category item2) =>
                        item1.serverId == item2.serverId,
                    itemAsString: (item) => item.name,
                    dropdownDecoratorProps: const DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "Category",
                        hintText: "Event category",
                      ),
                    ),
                    validator: (value) => value == null ? 'required' : null,
                    onChanged: (selected) {
                      selectedCategory = selected;
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        print(nameController.text);
                        http
                            .post(
                          Uri.parse('http://10.0.2.2:5000/api/events.json'),
                          headers: {'Content-Type': 'application/json'},
                          body: jsonEncode(
                            {
                              'event': {
                                'name': nameController.text,
                                'category_id': widget.categories
                                    .lastWhere((element) =>
                                        element.serverId ==
                                        selectedCategory!.serverId)
                                    .serverId,
                              },
                            },
                          ),
                        )
                            .then((value) {
                          Navigator.pop(
                              context,
                              Event(
                                name: nameController.text,
                                category: categoryController.text,
                                timestamp: DateTime.now(),
                                observation: '',
                              ));
                        });
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
