import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../pages/auth_service.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  bool _showPasswordFields = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final authService = AuthService();
    final userData = await authService.getUserData();

    if (userData != null) {
      final user = jsonDecode(userData);
      setState(() {
        _nameController.text = user['name'] ?? '';
        _emailController.text = user['email'] ?? '';
      });
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = AuthService();
      final token = await authService.getToken();

      // Prepare request body
      final Map<String, dynamic> requestBody = {
        'name': _nameController.text,
        'email': _emailController.text,
      };

      // Only include password fields if new password is provided
      if (_newPasswordController.text.isNotEmpty) {
        requestBody['currentPassword'] = _currentPasswordController.text;
        requestBody['newPassword'] = _newPasswordController.text;
      }

      final response = await http.put(
        Uri.parse('http://192.168.1.58:5000/api/users/me'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token ?? '',
        },
        body: jsonEncode(requestBody),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == true) {
        // Update local storage with new data
        await authService.saveUserSession(
          token!,
          jsonEncode(responseBody['user']),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );

        // Clear password fields if they were used
        if (_newPasswordController.text.isNotEmpty) {
          _currentPasswordController.clear();
          _newPasswordController.clear();
          setState(() => _showPasswordFields = false);
        }
      } else {
        throw Exception(responseBody['error'] ?? 'Failed to update profile');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _updateProfile,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _showPasswordFields = !_showPasswordFields;
                        });
                      },
                      child: Text(_showPasswordFields ? 'Hide Password Change' : 'Change Password'),
                    ),
                    if (_showPasswordFields) ...[
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _currentPasswordController,
                        decoration: const InputDecoration(labelText: 'Current Password'),
                        obscureText: true,
                        validator: (value) {
                          if (_newPasswordController.text.isNotEmpty && 
                              (value == null || value.isEmpty)) {
                            return 'Please enter current password';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _newPasswordController,
                        decoration: const InputDecoration(labelText: 'New Password'),
                        obscureText: true,
                        validator: (value) {
                          if (_showPasswordFields && (value == null || value.isEmpty)) {
                            return 'Please enter new password';
                          }
                          if (value != null && value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }
}