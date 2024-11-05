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
  final observationTxtCtrl = TextEditingController();
  final timestampCtrl = TextEditingController();

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
                  TextFormField(
                    controller: observationTxtCtrl,
                    decoration: const InputDecoration(
                      label: Text('Observation'),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: timestampCtrl,
                          readOnly: true,
                          onTap: getTimestamp,
                          decoration: InputDecoration(
                            label: const Text('Timestamp'),
                            suffixIcon: timestampCtrl.text != ''
                                ? IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () => setState(() {
                                          timestampCtrl.clear();
                                        }))
                                : null,
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: getTimestamp,
                          icon: const Icon(Icons.calendar_month)),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
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
                                'observation': observationTxtCtrl.text,
                                'timestamp': timestampCtrl.text
                              },
                            },
                          ),
                        )
                            .then((value) {
                          Navigator.pop(
                              context,
                              Event(
                                name: nameController.text,
                                category: widget.categories
                                    .lastWhere((element) =>
                                        element.serverId ==
                                        selectedCategory!.serverId)
                                    .name,
                                timestamp: DateTime.parse(timestampCtrl.text),
                                observation: observationTxtCtrl.text,
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

  void getTimestamp() {
    showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
    ).then((dateValue) {
      if (dateValue != null) {
        showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        ).then((timeValue) {
          setState(() {
            timestampCtrl.text = timeValue != null
                ? DateTime(
                    dateValue.year,
                    dateValue.month,
                    dateValue.day,
                    timeValue.hour,
                    timeValue.minute,
                  ).toIso8601String()
                : DateTime.now().toIso8601String();
          });
        });
      }
    });
  }
}
