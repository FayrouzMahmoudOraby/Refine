import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class AssignTrainingPage extends StatefulWidget {
  @override
  _AssignTrainingPageState createState() => _AssignTrainingPageState();
}

class _AssignTrainingPageState extends State<AssignTrainingPage> {
  DateTime? _selectedDate;
  List<dynamic> _players = [];
  List<dynamic> _trainings = [];

  String? _selectedPlayerId;
  String? _selectedTrainingId;

  @override
  void initState() {
    super.initState();
    fetchPlayers();
    fetchTrainings();
  }

  Future<void> fetchPlayers() async {
    final response = await http.get(
      Uri.parse('http://192.168.1.58:5000/api/users/players'),
    );

    if (response.statusCode == 200) {
      setState(() {
        _players = json.decode(response.body);
      });
    } else {
      print('Failed to load players');
    }
  }

  Future<void> fetchTrainings() async {
    final response = await http.get(
      Uri.parse('http://192.168.1.58:5000/api/trainings'),
    );

    if (response.statusCode == 200) {
      setState(() {
        _trainings = json.decode(response.body);
      });
    } else {
      print('Failed to load trainings');
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

  Future<void> _assignTraining() async {
    if (_selectedPlayerId == null ||
        _selectedTrainingId == null ||
        _selectedDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please select all fields.")));
      return;
    }

    final body = {
      "playerId": _selectedPlayerId,
      "trainingId": _selectedTrainingId,
      "date": _selectedDate!.toIso8601String(),
    };

    final response = await http.post(
      Uri.parse('http://192.168.1.58:5000/api/trainings/assign'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Training assigned successfully!")),
      );
      setState(() {
        _selectedDate = null;
        _selectedPlayerId = null;
        _selectedTrainingId = null;
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error assigning training.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate =
        _selectedDate != null
            ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
            : '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Assign Training to Player'),
        backgroundColor: Color(0xFF005BBB),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Select Player',
                border: OutlineInputBorder(),
              ),
              items:
                  _players.map((player) {
                    return DropdownMenuItem<String>(
                      value: player['_id'],
                      child: Text(player['name']),
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
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Select Training',
                border: OutlineInputBorder(),
              ),
              items:
                  _trainings.map((training) {
                    return DropdownMenuItem<String>(
                      value: training['_id'],
                      child: Text(training['title']),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTrainingId = value;
                });
              },
              value: _selectedTrainingId,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _pickDate(context),
              child: Text('Select Training Date'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF005BBB),
              ),
            ),
            if (_selectedDate != null) ...[
              SizedBox(height: 10),
              Text(
                'Selected Date: $formattedDate',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _assignTraining,
                child: Text('Assign Training'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
