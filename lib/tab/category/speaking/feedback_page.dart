import 'package:flutter/material.dart';
import 'package:good_swimming/tab/category/speaking/speaking_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class FeedbackItem {
  final String originalText;
  final String fixText;

  FeedbackItem({required this.originalText, required this.fixText});

  String toString() {
    return 'FeedbackItem{origianl_sentence: $originalText, fix_sentence: $fixText}';
  }
}

class FeedbackPage extends StatefulWidget {
  FeedbackPage({required this.topicId});
  final int topicId;

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final List<FeedbackItem> _feedbackList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          'http://www.good-at-swimming-back.store/chat/feedback/${widget.topicId}'));

      if (response.statusCode == 200) {
        final List<dynamic> feedbackData = jsonDecode(response.body);
        List<FeedbackItem> feedbackItems = feedbackData
            .map((item) => FeedbackItem(
                  originalText: item['original_sentence'],
                  fixText: item['fix_sentence'],
                ))
            .toList();

        setState(() {
          _feedbackList.clear();
          _feedbackList.addAll(feedbackItems);
        });
      } else {
        throw Exception('피드백 데이터 로드 실패');
      }
    } catch (error) {
      print('Error fetching data: $error');
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SpeakingPage()));
            },
          ),
          title: const Text(
            'FEEDBACK',
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.bold, fontFamily: 'En'),
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
                          Flexible(
                            child: Text(
                              feedback.originalText,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontFamily: 'En'),
                              //maxLines: 2,
                            ),
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
                              Flexible(
                                child: Text(
                                  feedback.fixText,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontFamily: 'En'),
                                  //maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
