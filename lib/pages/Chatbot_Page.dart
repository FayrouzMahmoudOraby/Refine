import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatbotPage extends StatefulWidget {
  @override
  _ChatbotPageState createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  TextEditingController _movementController = TextEditingController();
  String _response = '';

  Future<String> sendMovementToGPT(Map<String, dynamic> movementData) async {
    const apiKey = 'YOUR_OPENAI_API_KEY';
  
    // Define the system message with the tennis rulebook
    const systemMessage = '''
    You are a tennis movement analysis expert. A JSON object will be sent to you with:
    - The movement type (e.g., serve, backhand, forehand)
    - Whether the movement was correct or not
    - Joint positions of the player
  
    Use the following rulebook to assess incorrect movements and provide actionable improvement tips. If the movement is correct, respond with "Correct. No feedback necessary."
  
    Rulebook Summary:
    - For a proper serve, the elbow and shoulder must be aligned, and the wrist must snap forward upon contact.
    - For a forehand, hips and shoulders should rotate together, and the racquet should follow through above the opposite shoulder.
    - For a backhand, both elbows must remain at or above waist level, and the non-dominant hand should assist during the backswing.
    ''';

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'gpt-4',
        'messages': [
          {'role': 'system', 'content': systemMessage},
          {'role': 'user', 'content': jsonEncode(movementData)},
        ],
        'temperature': 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['choices'][0]['message']['content'];
    } else {
      throw Exception('Failed to contact ChatGPT API: ${response.body}');
    }
  }

  void _getResponse() async {
    Map<String, dynamic> movementData = {
      'movement_type': 'serve',
      'is_correct': false,
      'joint_positions': {
        'elbow': 'incorrect', // Example position, modify as needed
        'shoulder': 'aligned',
      },
    };

    try {
      String result = await sendMovementToGPT(movementData);
      setState(() {
        _response = result;
      });
    } catch (e) {
      setState(() {
        _response = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tennis Movement Analysis'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _movementController,
              decoration: InputDecoration(
                labelText: 'Enter Movement Data (JSON format)',
                hintText: '{"movement_type": "forehand", "is_correct": true, "joint_positions": {}}',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getResponse,
              child: Text('Send to GPT'),
            ),
            SizedBox(height: 20),
            Text(
              'Response from GPT-4:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(_response),
          ],
        ),
      ),
    );
  }
}
