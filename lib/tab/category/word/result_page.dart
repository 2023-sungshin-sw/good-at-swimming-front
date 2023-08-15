import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
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
  List<Map<String, String>> wrongWords = [];

  @override
  void initState() {
    super.initState();
    fetchWrongWords();
  }

  Future<void> fetchWrongWords() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://www.good-at-swimming-back.store/words/exam/result?id=1'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> dataList = data['data'];

        List<Map<String, String>> words =
            dataList.map<Map<String, String>>((item) {
          return {
            'word': item['word'],
            'meaning': item['meaning'],
          };
        }).toList();

        setState(() {
          wrongWords = words;
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
          onPressed: () {},
        ),
        title: const Text(
          'VOCA',
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.5,
              fontFamily: 'Player'),
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
              child: Center(
                child: Text(
                  'RESULT', // 결과 타원 안의 텍스트
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Black Han Sans',
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
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
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '0 / ${wrongWords.length}', // 점수 박스 (맞은 갯수 / 전체 문제 수)
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'IBM Plex Sans KR',
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: wrongWords.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Container(
                        width: 325,
                        height: 80,
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: const Color(0xFF121F33),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  wrongWords[index]['word'] ?? '', // 틀린 영단어
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  wrongWords[index]['meaning'] ??
                                      '뜻 없음', // 영단어 뜻
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10), // 추가: 단어박스 사이 간격
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
