import 'package:flutter/material.dart';
//import 'package:good_swimming/tab/category/translation/scan_page.dart';
import 'package:good_swimming/tab/tab_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ScanTranslatePage extends StatefulWidget {
  const ScanTranslatePage({super.key});

  @override
  _TranslatePageState createState() => _TranslatePageState();
}

class WordWithMeaning {
  final String word;
  final String meaning;
  
  WordWithMeaning(this.word, this.meaning);
}


class _TranslatePageState extends State<ScanTranslatePage> {
  bool isEnglishToKorean = true; // English to Korean 번역 모드인지 여부
  String exampleText = 'Hello, this is a test text for translation.';
  String translated_text = ''; // 번역된 텍스트

  void toggleTranslationMode() {
    setState(() {
      isEnglishToKorean = !isEnglishToKorean;
      translated_text = ''; // 번역 모드 전환 시 번역된 텍스트 초기화
    });
  }

  @override
  void initState() {
    super.initState();
    translateText();
  }

  void translateText() async {
    const apiKey = '0xCbUHelsHfXKY9aTDHN';
    // API 요청 및 응답 처리
    String predefinedText =
        'Hello, this is a test text for translation.'; //스캔해서 받아올 텍스트 예시
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
          'text': predefinedText,
        },
      );

      if (response.statusCode == 200) {
        final translatedData = json.decode(response.body);
        setState(() {
          translated_text =
              translatedData['message']['result']['translatedText'];
        });
      } else {
        setState(() {
          translated_text = 'Error: Unable to translate';
        });
      }
    } else {
      setState(() {
        translated_text = 'Error: API key not provided';
      });
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
            Container(
              width: 330,
              height: 200,
              padding: const EdgeInsets.all(16),
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
              child: Column(
                children: [
                  Text(isEnglishToKorean ? 'English' : 'Korean',
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.left),
                  Text(
                    isEnglishToKorean
                        ? 'Hello, this is a test text for translation.'
                        : '안녕하세요, 번역을 위한 테스트 텍스트입니다.',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Container(
              width: 330,
              height: 200,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF5C65BB),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(isEnglishToKorean ? 'Korean' : 'English',
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.left),
                  Text(
                    translated_text,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 330,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(30),
                    color: const Color(0xFF1A254F),
                  ),
                ),
                if (isEnglishToKorean)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'English',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 70,
                        height: 70,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF152F8D),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.swap_horiz),
                          color: Colors.white,
                          iconSize: 40,
                          onPressed: toggleTranslationMode,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Korean',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ],
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Korean',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 70,
                        height: 70,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF152F8D),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.swap_horiz),
                          color: Colors.white,
                          iconSize: 40,
                          onPressed: toggleTranslationMode,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'English',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
              ],
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
