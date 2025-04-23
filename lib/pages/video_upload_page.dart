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

  // Show a dialog with an error message
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
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Handle file upload to the AI API
  Future<void> _uploadVideo(File videoFile) async {
    setState(() {
      _isUploading = true;
    });

    try {
      // Create multipart request to send the video file
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          'http://192.168.1.58:500/api/videos/upload',
        ), // Replace with your backend URL
      );

      // Attach the video file using the file path
      request.files.add(
        await http.MultipartFile.fromPath('video', videoFile.path),
      );

      // Add additional fields
      request.fields['userId'] = 'user123'; // Replace with the actual user ID

      // Send the request and get the response
      var response = await request.send();

      if (response.statusCode == 200) {
        // Parse the response body
        var responseBody = await response.stream.bytesToString();
        var parsedResponse = json.decode(responseBody);

        // Show success dialog with analysis results
        _showSuccessDialog(parsedResponse);
      } else {
        throw Exception('Failed to upload video');
      }
    } catch (error) {
      // Handle errors
      _showErrorDialog('Upload Failed', error.toString());
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  // Allow the user to select a video file
  Future<void> _pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null) {
      File videoFile = File(result.files.single.path!);

      // Upload the video using the file path
      await _uploadVideo(videoFile);
    }
  }

  // Show a success dialog with analysis results
  void _showSuccessDialog(Map<String, dynamic> analysis) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Analysis Complete'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  'JSON Response:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                SelectableText(
                  JsonEncoder.withIndent('  ').convert(analysis),
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Video Upload')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: _pickVideo,
                child: Text('Upload Video'),
              ),
              if (_isUploading) CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}