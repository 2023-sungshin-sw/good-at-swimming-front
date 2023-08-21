import 'package:flutter/material.dart';
import 'package:good_swimming/tab/category/speaking/chat_page.dart';
import 'package:good_swimming/tab/home/home_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class FeedbackItem {
  final String originalText;
  final String fixText;

  FeedbackItem({required this.originalText, required this.fixText});
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FeedbackPage(),
    );
  }
}

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  List<FeedbackItem> _feedbackList = [];
  String feedback_id = '22';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  String API = 'http://www.good-at-swimming-back.store/chat/feedback/48';

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(API));

    if (response.statusCode == 200) {
      final List<dynamic> feedbackData =
          jsonDecode(utf8.decode(response.bodyBytes));

      print(feedbackData);
      setState(() {
        _feedbackList = feedbackData
            .map((feedback) => FeedbackItem(
                  originalText: feedback['original_sentence'],
                  fixText: feedback['fix_sentence'],
                ))
            .toList();
      });
    } else {
      throw Exception('Failed to load feedback data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF030C1A),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
          title: const Text(
            'FEEDBACK',
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontFamily: 'Player'),
          ),
          centerTitle: true,
        ),
        backgroundColor: const Color(0xFF030C1A),
        body: SingleChildScrollView(
          child: Column(
            children: _feedbackList.map((feedback) {
              return Column(
                children: [
                  SizedBox(height: 20),
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFF5C65BB),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            feedback.originalText,
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                feedback.fixText,
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
