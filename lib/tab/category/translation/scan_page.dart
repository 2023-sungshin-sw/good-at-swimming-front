import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

String apiKey = 'K84619122888957';

String parsedtext = '';

Future _getFromGallery() async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (pickedFile == null) return;

  var bytes = File(pickedFile.path.toString()).readAsBytesSync();
  String img64 = base64Encode(bytes);

  var url = 'https://api.ocr.space/parse/image';
  var payload = {"base64Image": "data:image/jpg;base64,${img64.toString()}"};
  var header = {"apikey" : apiKey};

  var post = await http.post(Uri.parse(url),body: payload,headers: header);
  var result = jsonDecode(post.body);

  // setState(() {
  //   parsedtext = result['ParsedResults'][0]['ParsedText'];
  // });
}

