/*import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String parsedtext = '';

  Future _getFromGallery() async {
    String apiKey = 'K84619122888957';
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    var bytes = await File(pickedFile.path).readAsBytes();
    String img64 = base64Encode(bytes);

    var url = 'https://api.ocr.space/parse/image';
    var payload = {"base64Image": "data:image/jpg;base64,$img64"};
    var header = {"apikey": apiKey};

    var post = await http.post(Uri.parse(url), body: payload, headers: header);
    var result = jsonDecode(post.body);

    setState(() {
      parsedtext = result['ParsedResults'][0]['ParsedText'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image OCR'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (parsedtext.isNotEmpty) Text(parsedtext),
            ElevatedButton(
              onPressed: _getFromGallery,
              child: Text('Select Image from Gallery'),
            ),
          ],
        ),
      ),
    );
  }
}*/
