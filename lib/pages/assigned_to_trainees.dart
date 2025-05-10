import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class AssignedToTraineesPage extends StatefulWidget {
  @override
  _AssignedToTraineesPageState createState() => _AssignedToTraineesPageState();
}

class _AssignedToTraineesPageState extends State<AssignedToTraineesPage> {
  DateTime? _selectedDate;
  TextEditingController _trainingController = TextEditingController();
  TextEditingController _durationController = TextEditingController();

  List<dynamic> _players = [];
  String? _selectedPlayerId;

  @override
  void initState() {
    super.initState();
    fetchPlayers();
  }

  Future<void> fetchPlayers() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:5000/api/users/players'),
    ); // Adjust URL for your IP if needed

    if (response.statusCode == 200) {
      setState(() {
        _players = json.decode(response.body);
      });
    } else {
      print('Failed to load players');
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now().add(Duration(days: 1)),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitTraining() async {
    if (_selectedPlayerId == null ||
        _selectedDate == null ||
        _trainingController.text.isEmpty ||
        _durationController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please fill all fields.")));
      return;
    }

    final body = {
      "playerId": _selectedPlayerId,
      "title": _trainingController.text,
      "date": _selectedDate!.toIso8601String(),
      "duration": _durationController.text,
    };

    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/api/trainings'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Training Assigned Successfully!")),
      );
      _trainingController.clear();
      _durationController.clear();
      setState(() {
        _selectedDate = null;
        _selectedPlayerId = null;
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error assigning training.")));
    }
  }

  @override
  void dispose() {
    _trainingController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate =
        _selectedDate != null
            ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
            : '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Assign Training to Trainee'),
        backgroundColor: Color(0xFF005BBB),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Select Trainee',
                border: OutlineInputBorder(),
              ),
              items:
                  _players.map((player) {
                    return DropdownMenuItem<String>(
                      value: player['_id'],
                      child: Text(player['name'] ?? 'Unnamed'),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPlayerId = value;
                });
              },
              value: _selectedPlayerId,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _pickDate(context),
              child: Text('Select Training Date'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF005BBB),
              ),
            ),
            SizedBox(height: 20),
            if (_selectedDate != null)
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Selected Date: ',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              formattedDate,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _trainingController,
                          decoration: InputDecoration(
                            labelText: 'Training Title',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _durationController,
                          decoration: InputDecoration(
                            labelText: 'Duration (e.g. 1 hour)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitTraining,
                    child: Text('Submit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
