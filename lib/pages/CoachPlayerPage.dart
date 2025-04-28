import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/add_player_form.dart';
import '../pages/player_detail_page.dart';

class CoachPlayerPage extends StatefulWidget {
  const CoachPlayerPage({super.key});

  @override
  State<CoachPlayerPage> createState() => _CoachPlayerPageState();
}

class _CoachPlayerPageState extends State<CoachPlayerPage> {
  List<Map<String, dynamic>> players = [];

  final String baseUrl =
      'http://192.168.3.153:5000/api/coachplayers/'; // ← change to your server

  @override
  void initState() {
    super.initState();
    fetchPlayers();
  }

  Future<void> fetchPlayers() async {
    final response = await http.get(Uri.parse('$baseUrl/'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        players =
            data
                .map(
                  (player) => {
                    '_id': player['_id'], // to be able to delete later
                    'name': player['name'],
                    'age': player['age'],
                    'description': player['description'],
                  },
                )
                .toList();
      });
    } else {
      // handle error
    }
  }

  Future<void> addPlayer(Map<String, String> player) async {
    final response = await http.post(
      Uri.parse('$baseUrl/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(player),
    );

    if (response.statusCode == 201) {
      fetchPlayers(); // refresh after adding
    } else {
      // handle error
    }
  }

  Future<void> removePlayer(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      fetchPlayers(); // refresh after delete
    } else {
      // handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF174BA8),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [const SizedBox(width: 20)],
            ),
            const SizedBox(height: 20),
            const CircleAvatar(radius: 30, backgroundColor: Colors.grey),
            const SizedBox(height: 10),
            const Text(
              "Welcome\ncoach Name",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(color: Color(0xFF30C3E2)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "My players",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Details about my players",
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddPlayerFormPage(),
                          ),
                        );

                        if (result != null && result is Map<String, String>) {
                          await addPlayer(result);
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: const Text("Add Player"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...players.map((player) {
                    return PlayerCard(
                      name: player['name']!,
                      description: player['description']!,
                      onDelete: () => removePlayer(player['_id']),
                      onNext: () {
                        // Navigate to PlayerDetailPage with the player ID
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) =>
                                    PlayerDetailPage(playerId: player['_id']),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlayerCard extends StatelessWidget {
  final String name;
  final String description;
  final VoidCallback onDelete;
  final VoidCallback onNext;

  const PlayerCard({
    super.key,
    required this.name,
    required this.description,
    required this.onDelete,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 0,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Icon(
                Icons.image,
                size: 300,
                color: Color.fromARGB(255, 189, 189, 189),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 45.0),
              child: Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(left: 45.0),
              child: Text(
                description,
                style: const TextStyle(
                  fontSize: 25,
                  color: Colors.black87,
                  fontWeight: FontWeight.w100,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 45.0),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: onDelete,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: const Text("Delete"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: onNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue,
                      side: const BorderSide(color: Colors.blue),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: const Text("Next"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
