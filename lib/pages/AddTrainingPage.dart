import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../pages/auth_service.dart'; // adjust this import as needed

class AddTrainingPage extends StatefulWidget {
  @override
  _AddTrainingPageState createState() => _AddTrainingPageState();
}

class _AddTrainingPageState extends State<AddTrainingPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  DateTime? _selectedDate;
  String? _playerId;

  @override
  void initState() {
    super.initState();
    _loadPlayerIdFromSession();
  }

  Future<void> _loadPlayerIdFromSession() async {
    final userDataString = await AuthService().getUserData();
    if (userDataString != null) {
      final userData = jsonDecode(userDataString);
      setState(() {
        _playerId = userData['_id']; // Adjust key if it's just 'id'
      });
    }
  }

  Future<void> _submitTraining() async {
    if (_titleController.text.isEmpty ||
        _durationController.text.isEmpty ||
        _selectedDate == null ||
        _playerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill all fields and wait for session to load."),
        ),
      );
      return;
    }

    final body = {
      "playerId": _playerId,
      "title": _titleController.text,
      "duration": _durationController.text,
      "date": _selectedDate!.toIso8601String(),
    };

    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/api/trainings'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Training Created Successfully!")));
      _titleController.clear();
      _durationController.clear();
      setState(() {
        _selectedDate = null;
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error creating training.")));
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate =
        _selectedDate != null
            ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
            : 'No date selected';

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Training'),
        backgroundColor: Color(0xFF005BBB),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Training Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _durationController,
              decoration: InputDecoration(
                labelText: 'Duration (e.g. 1 hour)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _pickDate(context),
              child: Text('Select Training Date'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF005BBB),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Selected Date: $formattedDate',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitTraining,
              child: Text('Create Training'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
