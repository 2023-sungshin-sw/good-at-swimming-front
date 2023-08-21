import 'package:flutter/material.dart';
import 'package:good_swimming/tab/category/word/word_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class Word {
  final int id;
  final String word;
  final String meaning;

  Word({required this.id, required this.word, required this.meaning});

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      id: json['voca_id'],
      word: json['word'],
      meaning: json['meaning'],
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ResultPage(),
    );
  }
}

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  int score = 0;
  List<Word> wrongWords = [];

  @override
  void initState() {
    super.initState();
    fetchWrongWords();
  }

  Future<void> fetchWrongWords() async {
    try {
      final response = await http.get(
        Uri.parse(
          'http://www.good-at-swimming-back.store/words/exam/result?id=1',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> dataList = data['data'];

        final fetchedScore = data['score'];
        setState(() {
          score = fetchedScore;
        });

        List<Word> fetchedWords = dataList.map<Word>((item) {
          return Word.fromJson(item);
        }).toList();

        setState(() {
          wrongWords = fetchedWords;
        });
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF030C1A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WordPage()),
            );
          },
        ),
        title: const Text(
          'VOCA',
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.5,
              fontFamily: 'En'),
        ),
      ),
      backgroundColor: const Color(0xFF030C1A),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 198,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                color: const Color(0xFF5C65BB),
              ),
              child: const Center(
                child: Text(
                  'RESULT', // 결과 타원 안의 텍스트
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'En',
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: 321,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFFBCC7EF),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 4,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${score} /20', // 점수 박스 (맞은 갯수 / 전체 문제 수)
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Kr',
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: wrongWords.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Container(
                        width: 325,
                        height: 80,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: const Color(0xFF121F33),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  wrongWords[index].word, // 틀린 영단어
                                  style: const TextStyle(
                                    fontFamily: 'En',
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  wrongWords[index].meaning,
                                  style: const TextStyle(
                                    fontFamily: 'Kr',
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10), // 추가: 단어박스 사이 간격
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
