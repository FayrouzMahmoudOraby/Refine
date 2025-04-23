import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VideoUploadPage extends StatefulWidget {
  @override
  _VideoUploadPageState createState() => _VideoUploadPageState();
}

class _VideoUploadPageState extends State<VideoUploadPage> {
  bool _isPermissionGranted = false;
  bool _isUploading = false;

  // Mobile-specific permission check (iOS/Android)
  Future<void> _checkMobilePermission() async {
    final status = await Permission.storage.status;
    if (status.isGranted) {
      setState(() {
        _isPermissionGranted = true;
      });
    } else {
      final result = await Permission.storage.request();
      setState(() {
        _isPermissionGranted = result.isGranted;
      });

      if (!_isPermissionGranted) {
        _showErrorDialog('Permission Denied', 'Storage permission required.');
      }
    }
  }

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

  // Handle file upload to the backend API
  Future<void> _uploadVideo(File videoFile) async {
    setState(() {
      _isUploading = true;
    });

    try {
      // Create multipart request to send the video file
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          'http://localhost:5000/api/videos/upload',
        ), // Replace with your backend URL
      );

      // Attach the video file
      request.files.add(
        await http.MultipartFile.fromPath('video', videoFile.path),
      );
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

  // Allow the user to select a video file (mobile)
  Future<void> _pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null) {
      File videoFile = File(result.files.single.path!);
      await _uploadVideo(videoFile); // Upload the selected video
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
  void initState() {
    super.initState();
    _checkMobilePermission(); // Check permission when the app starts
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
              if (_isPermissionGranted)
                ElevatedButton(
                  onPressed: _pickVideo,
                  child: Text('Upload Video'),
                ),
              if (!_isPermissionGranted)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Storage permission is required to upload videos.'),
                      ElevatedButton(
                        onPressed: _checkMobilePermission,
                        child: Text('Request Permission'),
                      ),
                    ],
                  ),
                ),
              if (_isUploading) CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
