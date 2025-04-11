import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:camera/camera.dart';

class VideoUploadPage extends StatefulWidget {
  @override
  _VideoUploadPageState createState() => _VideoUploadPageState();
}

class _VideoUploadPageState extends State<VideoUploadPage> {
  bool _isPermissionGranted = false;
  bool _isRecording = false;
  bool _isPaused = false;

  // Mobile camera properties
  CameraController? _cameraController;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _checkMobilePermission();
  }

  // Mobile-specific permission check (iOS/Android)
  Future<void> _checkMobilePermission() async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      setState(() {
        _isPermissionGranted = true;
      });
      _initializeCamera();
    } else {
      setState(() {
        _isPermissionGranted = false;
      });
      _showErrorDialog('Permission Denied', 'Camera permission required.');
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

  // Handle file upload (mobile)
  Future<void> _uploadVideo() async {
    setState(() {
      _isUploading = true;
    });

    // Simulate a delay for uploading
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isUploading = false;
    });

    _showErrorDialog('Upload Successful', 'Your video has been uploaded.');
  }

  // Allow the user to select a video file (mobile)
  Future<void> _pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );
    if (result != null) {
      // Simulate video upload
      await _uploadVideo();
    }
  }

  // Initialize camera (mobile-only)
  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      _cameraController = CameraController(
        cameras[0],
        ResolutionPreset.medium,
      );
      await _cameraController?.initialize();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Video Upload / Recording')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (_isPermissionGranted)
                Column(
                  children: [
                    // Mobile-specific camera preview
                    if (_cameraController?.value.isInitialized ?? false)
                      Container(
                        height: 200,
                        width: 200,
                        child: CameraPreview(_cameraController!),
                      ),
                    ElevatedButton(
                      onPressed: _pickVideo,
                      child: Text('Upload Video'),
                    ),
                  ],
                ),
              if (_isUploading) CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
