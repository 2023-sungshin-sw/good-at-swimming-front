import 'package:flutter/material.dart';

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
  final List<FeedbackItem> _feedbackList = [
    FeedbackItem(originalText: 'Original Text 1', fixText: 'Fix Text 1'),
    FeedbackItem(originalText: 'Original Text 2', fixText: 'Fix Text 2'),
    FeedbackItem(originalText: 'Original Text 3', fixText: 'Fix Text 3'),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF030C1A),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {},
          ),
          title: const Text(
            'FEEDBACK',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        backgroundColor: const Color(0xFF030C1A),
        body: SingleChildScrollView(
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(8),
            itemCount: _feedbackList.length,
            itemBuilder: (BuildContext context, int index) {
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
                            _feedbackList[index].originalText,
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 5),
                              Text(
                                _feedbackList[index].fixText,
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.white),
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
            },
          ),
        ),
      ),
    );
  }
}
