import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:good_swimming/tab/category/category_page.dart';
import 'package:good_swimming/tab/category/speaking/feedback_page.dart';
import 'package:good_swimming/tab/category/speaking/speaking_page.dart';
import 'package:good_swimming/tab/category/translation/translation_page.dart';
import 'package:good_swimming/tab/category/word/create_page.dart';
import 'package:good_swimming/logIn/signUp_page.dart';
import 'package:good_swimming/tab/category/word/result_page.dart';
import 'package:good_swimming/tab/category/word/test_page.dart';
import 'package:good_swimming/tab/category/word/word_page.dart';
import 'package:good_swimming/tab/home/home_page.dart';
import 'package:good_swimming/tab/tab_page.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: FeedbackPage());
  }
}
