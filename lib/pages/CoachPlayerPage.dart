import 'package:flutter/material.dart';
import '../widgets/add_player_form.dart';

class CoachPlayerPage extends StatefulWidget {
  const CoachPlayerPage({super.key});

  @override
  State<CoachPlayerPage> createState() => _CoachPlayerPageState();
}

class _CoachPlayerPageState extends State<CoachPlayerPage> {
  List<Map<String, String>> players = [];

  void addPlayer(Map<String, String> player) {
    setState(() {
      players.add(player);
    });
  }

  void removePlayer(int index) {
    setState(() {
      players.removeAt(index);
    });
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
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 20,
              ), // ← Margin added
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

                  // 🆕 Add Player Button (moved inside)
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
                          addPlayer(result);
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

                  ...players.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, String> player = entry.value;
                    return PlayerCard(
                      name: player['name']!,
                      description: player['description']!,
                      onDelete: () => removePlayer(index),
                      onNext: () {
                        // handle "Next" button action here
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Next pressed for ${player['name']}'),
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
          crossAxisAlignment: CrossAxisAlignment.start, // Align everything left
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
                textAlign: TextAlign.left,
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
                textAlign: TextAlign.left,
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
