import 'package:flutter/material.dart';
import 'package:good_swimming/tab/category/translation/camera_screen.dart';
//import 'package:good_swimming/tab/category/translation/scan_page.dart';
import 'package:good_swimming/tab/tab_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ScanTranslatePage extends StatefulWidget {
  const ScanTranslatePage({super.key, required this.parsedText});
  final String parsedText;

  @override
  _ScanTranslatePageState createState() => _ScanTranslatePageState();
}

class _ScanTranslatePageState extends State<ScanTranslatePage> {
  bool isEnglishToKorean = true; // English to Korean 번역 모드인지 여부
  List<String> translated_text = []; // 번역된 텍스트
  List<String> predefinedText = [
    'We have to finish our project today.',
    'We will be the winning team.'
  ]; //스캔해서 받아올 문장 리스트 예시
  final List<String> _selectedWords = []; //저장할 단어 리스트
  late String selectedWord;
  late String translatedWord = ' ';
  final List<String> _translateWords = [];

  bool isEmpty = true;
  final List<WordWithMeaning> _wordWithMeaning = [];

  List<String> splitSentencesIntoWords(predefinedText) {
    List<String> words = [];

    for (String sentence in predefinedText) {
      List<String> sentenceWords = sentence.split(' '); // 공백을 기준으로 단어 나누기
      words.addAll(sentenceWords);
    }
    return words;
  }

  @override
  void initState() {
    super.initState();
    translateText();
  }

  void translateText() async {
    const apiKey = '0xCbUHelsHfXKY9aTDHN';
    // API 요청 및 응답 처리

    if (apiKey.isNotEmpty) {
      final url = Uri.parse("https://openapi.naver.com/v1/papago/n2mt");
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          'X-Naver-Client-Id': apiKey,
          'X-Naver-Client-Secret': 'jvv3y0TnEf',
        },
        body: {
          'source': isEnglishToKorean ? 'en' : 'ko',
          'target': isEnglishToKorean ? 'ko' : 'en',
          'text': predefinedText.join('\n'),
        },
      );

      if (response.statusCode == 200) {
        final translatedData = json.decode(response.body);
        setState(() {
          translated_text = translatedData['message']['result']
                  ['translatedText']
              .toString()
              .split('/n');
        });
      } else {
        setState(() {
          print('Error: Unable to translate');
        });
      }
    } else {
      setState(() {
        print('Error: API key not provided');
      });
    }
  }

  void translateWord() async {
    const apiKey = '0xCbUHelsHfXKY9aTDHN';
    // API 요청 및 응답 처리

    if (apiKey.isNotEmpty) {
      final url = Uri.parse("https://openapi.naver.com/v1/papago/n2mt");
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          'X-Naver-Client-Id': apiKey,
          'X-Naver-Client-Secret': 'jvv3y0TnEf',
        },
        body: {
          'source': isEnglishToKorean ? 'en' : 'ko',
          'target': isEnglishToKorean ? 'ko' : 'en',
          'text': selectedWord,
        },
      );

      if (response.statusCode == 200) {
        final translatedData = json.decode(response.body);
        final translatedText =
            translatedData['message']['result']['translatedText'];

        setState(() {
          translatedWord = translatedText;
          _translateWords.add(translatedWord);
        });
        print(_translateWords);
        sendData();
      } else {
        setState(() {
          print('Error: Unable to translate');
        });
      }
    }
  }

  Future<void> sendData() async {
    for (int i = 0; i < _selectedWords.length; i++) {
      final word = _selectedWords[i];
      final meaning = _translateWords[i];

      final newWordMeaning = WordWithMeaning(
        user: 1,
        word: word,
        meaning: meaning,
      );

      try {
        final response = await http.post(
          Uri.parse('http://www.good-at-swimming-back.store/words/'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(newWordMeaning.toJson()),
        );

        if (response.statusCode == 200) {
          setState(() {
            _wordWithMeaning.add(newWordMeaning);
            _wordWithMeaning.clear();
          });
          showToast('단어가 저장되었습니다!');
        } else {
          showToast('서버로 데이터 전송에 실패했습니다');
        }
      } catch (e) {
        print('Error: $e');
        showToast('오류가 발생했습니다');
      }
      setState(() {
        _selectedWords.clear();
        _translateWords.clear();
      });
    }
  }

  void showToast(String message) {
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
                fontFamily: 'En',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030C1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF030C1A),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const TabPage(selectedTab: 1)),
            );
          },
        ),
        title: const Text(
          'TRANSLATE',
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.5,
              fontFamily: 'En'),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: const Text(
                          '텍스트를 누르면 단어가 저장됩니다',
                          style: TextStyle(fontFamily: 'Kr'),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              '닫기',
                              style: TextStyle(fontFamily: 'Kr'),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text(
                  'TIP',
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'En',
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              Container(
                width: 330,
                height: 200,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF5C65BB),
                      Color.fromARGB(255, 153, 156, 197)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text('English',
                          style: TextStyle(
                              fontFamily: 'En',
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 2,
                        children: predefinedText.expand((sentence) {
                          return sentence.split(' ').map((word) {
                            return Stack(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      _selectedWords.add(word);
                                      int lastIndex = _selectedWords.length - 1;
                                      selectedWord = _selectedWords[lastIndex];
                                      translateWord();
                                      print(_selectedWords);
                                    });
                                  },
                                  child: Text(
                                    word,
                                    style: const TextStyle(
                                        fontSize: 16, fontFamily: 'En'),
                                  ),
                                ),
                              ],
                            );
                          }).toList();
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40),
              Container(
                width: 330,
                height: 200,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF5C65BB),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text('Korean',
                          style: TextStyle(
                              fontFamily: 'Kr',
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left),
                      const SizedBox(height: 10),
                      Text(
                        translated_text.join(' '),
                        style: const TextStyle(fontSize: 16, fontFamily: 'Kr'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF152F8D),
                ),
                child: IconButton(
                  icon: const Icon(Icons.camera_alt),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CameraScreen()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WordWithMeaning {
  final int user;
  final String word;
  final String meaning;

  WordWithMeaning(
      {required this.user, required this.word, required this.meaning});

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'word': word,
      'meaning': meaning,
    };
  }

  factory WordWithMeaning.fromJson(Map<String, dynamic> json) {
    return WordWithMeaning(
      user: json['user'],
      word: json['word'],
      meaning: json['meaning'],
    );
  }
}
