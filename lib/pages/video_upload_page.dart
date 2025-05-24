import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VideoUploadPage extends StatefulWidget {
  @override
  _VideoUploadPageState createState() => _VideoUploadPageState();
}

class _VideoUploadPageState extends State<VideoUploadPage> {
  bool _isUploading = false;
  String _technicalAnalysis = '';
  String _coachFeedback = '';

  Future<void> _uploadVideo(File videoFile) async {
    setState(() {
      _isUploading = true;
      _technicalAnalysis = '';
      _coachFeedback = '';
    });

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://10.0.2.2:5000/api/videos/upload'),
      );

      request.files.add(
        await http.MultipartFile.fromPath('video', videoFile.path),
      );
      request.fields['userId'] = 'user123';

      var response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final parsedResponse = json.decode(responseBody);
        setState(() {
          _technicalAnalysis = JsonEncoder.withIndent(
            '  ',
          ).convert(parsedResponse['technicalAnalysis']);
          _coachFeedback = parsedResponse['coachFeedback'];
        });
      } else {
        throw Exception('Failed to upload video: ${response.statusCode}');
      }
    } catch (error) {
      _showErrorDialog('Upload Failed', error.toString());
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> _pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null) {
      await _uploadVideo(File(result.files.single.path!));
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tennis Movement Analysis')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _pickVideo,
              child: Text('Upload Tennis Video'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              ),
            ),
            SizedBox(height: 20),
            if (_isUploading) ...[
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Analyzing your tennis movement...'),
            ],
            if (_coachFeedback.isNotEmpty) ...[
              Text(
                'Coach Feedback:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(_coachFeedback),
                ),
              ),
              SizedBox(height: 20),
              ExpansionTile(
                title: Text('Technical Analysis (JSON)'),
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SelectableText(
                      _technicalAnalysis,
                      style: TextStyle(fontFamily: 'monospace'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
