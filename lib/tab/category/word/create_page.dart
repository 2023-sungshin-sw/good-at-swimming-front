import 'package:flutter/material.dart';
import 'package:good_swimming/tab/category/word/word_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CreatePage(),
    );
  }
}

//test
class CreatePage extends StatefulWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final TextEditingController _wordController = TextEditingController();
  final TextEditingController _meaningController = TextEditingController();
  final TextEditingController _example_enController = TextEditingController();
  final TextEditingController _example_krController = TextEditingController();

  final List<WordData> _wordDataList = [];

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
      body: SingleChildScrollView(
        // 스크롤 가능한 컬럼을 감싸서 오버플로우 문제 해결
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              _buildInputField(
                controller: _wordController,
                labelText: 'ENGLISH',
                hintText: '영단어를 입력해주세요',
              ),
              const SizedBox(height: 20),
              _buildInputField(
                controller: _meaningController,
                labelText: 'KOREAN',
                hintText: '뜻을 입력해주세요',
              ),
              const SizedBox(height: 20),
              _buildInputField(
                controller: _example_enController,
                labelText: 'EXAMPLE',
                hintText: '예문을 입력해주세요',
              ),
              const SizedBox(height: 20),
              _buildInputField(
                controller: _example_krController,
                labelText: 'EXAMPLE_KR',
                hintText: '예문의 뜻을 입력해주세요',
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _addWord,
                icon: const Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                  size: 60.0,
                ),
                label: const SizedBox.shrink(),
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
              ),
              const SizedBox(height: 40),
              ListView.builder(
                shrinkWrap: true, // 추가
                itemCount: _wordDataList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      _wordDataList[index].word,
                      style: TextStyle(fontFamily: 'En'),
                    ),
                    subtitle: Text(
                      _wordDataList[index].meaning,
                      style: TextStyle(fontFamily: 'Kr'),
                    ),
                    trailing: const Icon(Icons.edit),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
  }) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: const Color(0xFF121F33),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 16,
      ),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.white),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }

  void _addWord() async {
    final wordText = _wordController.text;
    final meaningText = _meaningController.text;

    if (wordText.isEmpty || meaningText.isEmpty) {
      _showToast('필수 항목을 모두 입력해주세요');
      return;
    }

    final newWordData = WordData(
      user: 1,
      word: wordText,
      meaning: meaningText,
      example_en: _example_enController.text,
      example_kr: _example_krController.text,
    );

    try {
      final response = await http.post(
        Uri.parse('http://www.good-at-swimming-back.store/words/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(newWordData.toJson()),
      );

      if (response.statusCode == 200) {
        setState(() {
          _wordDataList.add(newWordData);
          _wordController.clear();
          _meaningController.clear();
          _example_enController.clear();
          _example_krController.clear();

          _showToast('저장에 성공했습니다');

          Future.delayed(const Duration(seconds: 3), () {
            Navigator.pop(context);
          });
        });
      } else {
        _showToast('서버로 데이터 전송에 실패했습니다');
      }
    } catch (e) {
      print('Error: $e');
      _showToast('오류가 발생했습니다');
    }
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          width: 311,
          height: 13,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 51, 50, 50),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Center(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Kr',
                fontSize: 10,
                fontWeight: FontWeight.w100,
              ),
            ),
          ),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }
}

class WordData {
  final int user;
  final String word;
  final String meaning;
  final String example_en;
  final String example_kr;

  WordData({
    required this.user,
    required this.word,
    required this.meaning,
    required this.example_en,
    required this.example_kr,
  });

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'word': word,
      'meaning': meaning,
      'example_en': example_en,
      'example_kr': example_kr,
    };
  }

  factory WordData.fromJson(Map<String, dynamic> json) {
    return WordData(
      user: json['user'],
      word: json['word'],
      meaning: json['meaning'],
      example_en: json['example_en'],
      example_kr: json['example_kr'],
    );
  }
}
