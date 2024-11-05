import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:event_counter/models/category.dart';

class CategoryFormPage extends StatefulWidget {
  const CategoryFormPage({super.key});

  @override
  State<CategoryFormPage> createState() => _CategoryFormPageState();
}

class _CategoryFormPageState extends State<CategoryFormPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Category'),
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
                          const InputDecoration(label: Text("Category Name")),
                      controller: nameController,
                      validator: (value) {
                        print(value);
                        return value == null || value == '' ? 'required' : null;
                      }),
                  TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        print(nameController.text);
                        http
                            .post(
                          Uri.parse('http://10.0.2.2:5000/api/categories.json'),
                          headers: {'Content-Type': 'application/json'},
                          body: jsonEncode(
                            {
                              'category': {
                                'name': nameController.text,
                              },
                            },
                          ),
                        )
                            .then((value) {
                          final id = jsonDecode(value.body)['id'];
                          Navigator.pop(
                              context,
                              Category(
                                name: nameController.text,
                                serverId: id,
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
