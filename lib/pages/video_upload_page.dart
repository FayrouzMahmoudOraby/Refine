import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';

class VideoUploadPage extends StatefulWidget {
  @override
  _VideoUploadPageState createState() => _VideoUploadPageState();
}

class _VideoUploadPageState extends State<VideoUploadPage> {
  bool _isPermissionGranted = false;
  bool _isWeb = false;
  bool _isRecording = false;
  bool _isPaused = false;
  html.MediaStream? _mediaStream;
  html.VideoElement? _videoElement;
  html.MediaRecorder? _mediaRecorder;
  List<html.Blob> _recordedChunks = [];
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _checkPlatform();
  }

  // Check the platform to handle permissions accordingly
  void _checkPlatform() {
    if (html.window.navigator.userAgent.contains("Chrome") ||
        html.window.navigator.userAgent.contains("Firefox")) {
      setState(() {
        _isWeb = true;
      });
      _checkWebPermission();
    } else if (Theme.of(context).platform == TargetPlatform.iOS) {
      setState(() {
        _isPermissionGranted = true;
      });
      _checkIOSPermission();
    } else if (Theme.of(context).platform == TargetPlatform.android) {
      setState(() {
        _isPermissionGranted = true;
      });
      _checkAndroidPermission();
    }
  }

  // Web-specific permission check
  Future<void> _checkWebPermission() async {
    final mediaDevices = html.window.navigator.mediaDevices;
    if (mediaDevices != null) {
      try {
        final stream = await mediaDevices.getUserMedia({'video': true});
        setState(() {
          _isPermissionGranted = true;
          _mediaStream = stream;
          _videoElement = html.VideoElement()..srcObject = stream;
        });
      } catch (error) {
        setState(() {
          _isPermissionGranted = false;
        });
        _showErrorDialog('Permission Denied', 'Camera permission required.');
      }
    }
  }

  // iOS-specific permission check
  Future<void> _checkIOSPermission() async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      setState(() {
        _isPermissionGranted = true;
      });
    } else {
      setState(() {
        _isPermissionGranted = false;
      });
      _showErrorDialog('Permission Denied', 'Camera permission required.');
    }
  }

  // Android-specific permission check
  Future<void> _checkAndroidPermission() async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      setState(() {
        _isPermissionGranted = true;
      });
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

  void _startRecording() {
    if (_mediaStream != null) {
      setState(() {
        _isRecording = true;
        _recordedChunks.clear();
      });

      _mediaRecorder = html.MediaRecorder(_mediaStream!);

      _mediaRecorder!.addEventListener('dataavailable', (event) {
        final blobEvent = event as html.BlobEvent;
        final blob = blobEvent.data;

        if (blob != null && blob.size > 0) {
          _recordedChunks.add(blob);
        }
      });

      _mediaRecorder!.start();
    }
  }

  // Pause recording video
  void _pauseRecording() {
    if (_mediaRecorder != null) {
      setState(() {
        _isPaused = true;
      });
      _mediaRecorder!.pause();
    }
  }

  // Stop recording video
  void _stopRecording() {
    if (_mediaRecorder != null) {
      _mediaRecorder!.stop();
      setState(() {
        _isRecording = false;
        _isPaused = false;
      });
      _showPreview();
    }
  }

  // Show the recorded video as a preview
  void _showPreview() {
    final blob = html.Blob(_recordedChunks);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final videoElement =
        html.VideoElement()
          ..src = url
          ..autoplay = true
          ..controls = true;

    setState(() {
      _videoElement = videoElement;
    });
  }

  // Handle file upload
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

  // Allow the user to select a video file
  Future<void> _pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );
    if (result != null) {
      // Simulate video upload
      await _uploadVideo();
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
              if (_isPermissionGranted && _isWeb)
                Column(
                  children: [
                    // Display the video stream (camera feed)
                    Container(
                      height: 200,
                      width: 200,
                      child: HtmlElementView(viewType: 'videoElement'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: _isRecording ? null : _startRecording,
                          child: Text('Start Recording'),
                        ),
                        ElevatedButton(
                          onPressed: _isRecording ? _pauseRecording : null,
                          child: Text('Pause Recording'),
                        ),
                        ElevatedButton(
                          onPressed: _isRecording ? _stopRecording : null,
                          child: Text('Stop Recording'),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _pickVideo,
                      child: Text('Upload Video'),
                    ),
                  ],
                ),
              if (_isUploading) CircularProgressIndicator(),
              if (_videoElement != null)
                Column(
                  children: [
                    Text('Preview of Recorded Video:'),
                    Container(
                      height: 200,
                      width: 200,
                      child: HtmlElementView(viewType: 'videoElement'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
