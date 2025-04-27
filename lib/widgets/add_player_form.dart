import 'package:flutter/material.dart';

class AddPlayerFormPage extends StatefulWidget {
  const AddPlayerFormPage({super.key});

  @override
  State<AddPlayerFormPage> createState() => _AddPlayerFormPageState();
}

class _AddPlayerFormPageState extends State<AddPlayerFormPage> {
  final _formKey = GlobalKey<FormState>();
  String name = "";
  String age = "";
  String description = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Player"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Player Name"),
                validator:
                    (value) =>
                        value == null || value.isEmpty ? "Enter a name" : null,
                onSaved: (value) => name = value!,
              ),
              const SizedBox(height: 15),
              TextFormField(
                decoration: const InputDecoration(labelText: "Age"),
                keyboardType: TextInputType.number,
                validator:
                    (value) =>
                        value == null || value.isEmpty ? "Enter an age" : null,
                onSaved: (value) => age = value!,
              ),
              const SizedBox(height: 15),
              TextFormField(
                decoration: const InputDecoration(labelText: "Description"),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? "Enter a description"
                            : null,
                onSaved: (value) => description = value!,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Navigator.pop(context, {
                      'name': name,
                      'age': age,
                      'description': description,
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 10,
                  ),
                ),
                child: const Text("Add Player"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
