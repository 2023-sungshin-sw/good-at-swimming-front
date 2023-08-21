import 'package:flutter/material.dart';
import 'package:good_swimming/tab/category/translation/scanTranslation_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class PhotoPreview extends StatefulWidget {
  final String imagePath;

  const PhotoPreview({required this.imagePath, Key? key}) : super(key: key);

  @override
  State<PhotoPreview> createState() => _PhotoPreviewState();
}

class _PhotoPreviewState extends State<PhotoPreview> {
  String parsedtext = ' ';
  Future<void> _performOCR() async {
    String apiKey = 'K83411673688957';

    var bytes = await File(widget.imagePath).readAsBytes();
    String img64 = base64Encode(bytes);

    print('Image Path: ${widget.imagePath}');

    var url = 'https://api.ocr.space/parse/image';
    var payload = {"base64Image": "data:image/jpg;base64,$img64"};
    var header = {"apikey": apiKey};

    var post = await http.post(Uri.parse(url), body: payload, headers: header);
    var result = jsonDecode(post.body);

    setState(() {
      var parsedText = result['ParsedResults'][0]['ParsedText'];
      print('Parsed Text: $parsedText'); // 디버그 프린트
      if (parsedText != null && parsedText.isNotEmpty) {
        parsedtext = parsedText;
      }
    });

    if (parsedtext.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScanTranslatePage(parsedText: parsedtext),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF030C1A),
        title: const Text(
          'Preview',
          style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.5,
              fontFamily: 'Player'),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0xFF030C1A),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.file(
                  File(widget.imagePath),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5C65BB)),
                onPressed: () async {
                  await _performOCR();
                },
                child: Text('Select'),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
