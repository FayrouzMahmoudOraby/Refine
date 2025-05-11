import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../pages/auth_service.dart';

class AddTrainingPage extends StatefulWidget {
  @override
  _AddTrainingPageState createState() => _AddTrainingPageState();
}

class _AddTrainingPageState extends State<AddTrainingPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  DateTime? _selectedDate;
  String? _userEmail;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserEmailFromSession();
  }

  Future<void> _loadUserEmailFromSession() async {
    final userDataString = await AuthService().getUserData();
    if (userDataString != null) {
      final userData = jsonDecode(userDataString);
      setState(() {
        _userEmail = userData['email']; // Changed from _id to email
      });
    }
  }

  Future<void> _submitTraining() async {
    // Dismiss keyboard first
    FocusScope.of(context).unfocus();

    // Validate all fields
    if (_titleController.text.trim().isEmpty) {
      _showError("Please enter a training title");
      return;
    }

    if (_durationController.text.trim().isEmpty) {
      _showError("Please enter the training duration");
      return;
    }

    if (_selectedDate == null) {
      _showError("Please select a training date");
      return;
    }

    if (_userEmail == null) {
      _showError("User email not loaded. Please try again.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('http://192.168.3.24:5000/api/trainings'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": _userEmail,  // Changed from playerId to email
          "title": _titleController.text.trim(),
          "duration": _durationController.text.trim(),
          "date": _selectedDate!.toIso8601String(),
        }),
      );

      if (response.statusCode == 201) {
        _showSuccess("Training created successfully!");
        _resetForm();
      } else {
        _showError("Failed to create training: ${response.body}");
      }
    } catch (e) {
      _showError("Network error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _resetForm() {
    _titleController.clear();
    _durationController.clear();
    setState(() {
      _selectedDate = null;
    });
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
    final String formattedDate = _selectedDate != null
        ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
        : 'No date selected';

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Training'),
        backgroundColor: Color(0xFF005BBB),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}