import 'package:flutter/material.dart';
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

class WordWithMeaning {
  final int user;
  final String word;
  final String meaning;

  WordWithMeaning(this.user, this.word, this.meaning);
}

class _ScanTranslatePageState extends State<ScanTranslatePage> {
  bool isEnglishToKorean = true; // English to Korean 번역 모드인지 여부
  List<String> translated_text = []; // 번역된 텍스트
  List<String> predefinedText = []; //스캔해서 받아올 문장 리스트 예시
  List<String> _selectedWords = []; //저장할 단어 리스트
  //List<String> _translatedWords = []; //번역된 단어 리스트
  late String selectedWord;
  late String translatedWord;
  List<String> _translateWords = [];
  bool _isButtonVisible = false;
  Offset? _buttonPosition;

  List<String> splitSentencesIntoWords(predefinedText) {
    List<String> words = [];

    for (String sentence in predefinedText) {
      List<String> sentenceWords = sentence.split(' '); // 공백을 기준으로 단어 나누기
      words.addAll(sentenceWords);
    }
    return words;
  }

  void _handleButtonPressed() {
    setState(() {
      _isButtonVisible = false; // 버튼을 눌렀으므로 다시 숨김
    });
  }

  @override
  void initState() {
    super.initState();
    predefinedText.add(widget.parsedText);
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
        });
      } else {
        setState(() {
          print('Error: Unable to translate');
        });
      }
    }
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
              fontFamily: 'Player'),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 40),
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
                            fontSize: 20, fontWeight: FontWeight.bold),
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
                                    //_selectedWords = [];
                                    _selectedWords.add(word);
                                    int lastIndex = _selectedWords.length - 1;
                                    //print(_selectedWords.length);
                                    selectedWord = _selectedWords[lastIndex];
                                    translateWord();
                                    _translateWords.add(translatedWord);
                                    int lastIndexOfTranslation =
                                        _translateWords.length;
                                    translatedWord = _translateWords[
                                        lastIndexOfTranslation - 1];
                                    //translateWord();
                                    //_translateWords.add(translatedWord);
                                    print(_translateWords);
                                    print(selectedWord);
                                    print(translatedWord);
                                  });
                                },
                                child: Text(
                                  word,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              if (_isButtonVisible)
                                Positioned(
                                  left: _buttonPosition!.dx,
                                  top: _buttonPosition!.dy,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _handleButtonPressed();
                                    },
                                    child: const Text('SAVE'),
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
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left),
                    const SizedBox(height: 10),
                    Text(
                      translated_text.join(' '),
                      style: const TextStyle(fontSize: 16),
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
                  /*Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ScanPage()),
                  );*/
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
