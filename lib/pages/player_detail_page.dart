import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlayerDetailPage extends StatefulWidget {
  final String playerId;

  const PlayerDetailPage({super.key, required this.playerId});

  @override
  _PlayerDetailPageState createState() => _PlayerDetailPageState();
}

class _PlayerDetailPageState extends State<PlayerDetailPage> {
  Map<String, dynamic> playerDetails = {}; // ✅ Initialize it empty

  final String baseUrl = 'http://10.0.2.2:5000/api/coachplayers/';

  @override
  void initState() {
    super.initState();
    fetchPlayerDetails();
  }

  Future<void> fetchPlayerDetails() async {
    final response = await http.get(Uri.parse('$baseUrl/${widget.playerId}'));

    if (response.statusCode == 200) {
      setState(() {
        playerDetails = json.decode(response.body);
      });
    } else {
      // handle error (optional: show error message)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF174BA8),
      appBar: AppBar(
        title: const Text('Player Details'),
        backgroundColor: const Color(0xFF30C3E2),
        actions: const [
          Icon(Icons.sports_soccer),
          Icon(Icons.sports_basketball),
        ],
      ),
      body:
          playerDetails.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      playerDetails['name'],
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Age: ${playerDetails['age']}',
                      style: const TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Description: ${playerDetails['description']}',
                      style: const TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ],
                ),
              ),
    );
  }
}
