import 'package:flutter/material.dart';
import 'package:good_swimming/tab/tab_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TranslatePage extends StatefulWidget {
  const TranslatePage({super.key});

  @override
  _TranslatePageState createState() => _TranslatePageState();
}

class _TranslatePageState extends State<TranslatePage> {
  bool isEnglishToKorean = true; // English to Korean 번역 모드인지 여부
  String inputText = ''; // 입력된 텍스트
  String translated_text = ''; // 번역된 텍스트

  void toggleTranslationMode() {
    setState(() {
      isEnglishToKorean = !isEnglishToKorean;
      inputText = ''; // 번역 모드 전환 시 입력된 텍스트 초기화
      translated_text = ''; // 번역 모드 전환 시 번역된 텍스트 초기화
    });
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
          'text': inputText,
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
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            if (isEnglishToKorean)
              Container(
                width: 330,
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0xFF5C65BB),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text('English',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.left),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Enter text',
                      ),
                      onChanged: (value) {
                        setState(() {
                          inputText = value;
                        });
                      },
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: translateText,
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 242, 84, 5)),
                      child: const Text(
                        'Translate',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              )
            else
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
                    const Text('Korean',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.left),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: '한국어 입력',
                      ),
                      onChanged: (value) {
                        setState(() {
                          inputText = value;
                        });
                      },
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: translateText,
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 242, 84, 5)),
                      child: const Text(
                        'Translate',
                        style: TextStyle(color: Colors.white),
                      ),
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
                        style: TextStyle(color: Colors.white),
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
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Korean',
                        style: TextStyle(color: Colors.white),
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
                        style: TextStyle(color: Colors.white),
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
                onPressed: toggleTranslationMode,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
