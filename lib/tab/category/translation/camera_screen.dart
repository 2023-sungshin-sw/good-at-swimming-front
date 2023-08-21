import 'package:flutter/material.dart';
import 'package:good_swimming/tab/category/translation/preview_page.dart';
import 'package:good_swimming/tab/category/translation/scanTranslation_page.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  bool _isCameraReady = false;

  @override
  void initState() {
    super.initState();

    availableCameras().then((cameras) {
      if (cameras.isNotEmpty && _cameraController == null) {
        _cameraController = CameraController(
          cameras.first,
          ResolutionPreset.medium,
        );

        _cameraController!.initialize().then((_) {
          setState(() {
            _isCameraReady = true;
          });
        });
      }
    });
  }

  void _onTakePicture(BuildContext context) async {
    if (_cameraController == null || !_isCameraReady) {
      return;
    }

    try {
      final image = await _cameraController!.takePicture();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PhotoPreview(imagePath: image.path),
        ),
      );
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF030C1A),
        title: const Text(
          'SCAN',
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.5,
              fontFamily: 'En'),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: _cameraController != null && _isCameraReady
                  ? CameraPreview(_cameraController!)
                  : Container(
                      color: const Color(0xFF030C1A),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5C65BB)),
                onPressed: _cameraController != null
                    ? () => _onTakePicture(context)
                    : null,
                child: const Text(
                  'Take a photo',
                  style: TextStyle(fontFamily: 'En'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
