import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flip_card/flip_card.dart';
import 'package:good_swimming/tab/category/word/result_page.dart';
import 'package:good_swimming/tab/category/word/word_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Word {
  final int voca_id;
  final String word;
  final String meaning;

  Word(this.voca_id, this.word, this.meaning);
}

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final CarouselController carouselController = CarouselController();
  List<Word> words = [];
  int current = 0;

  @override
  void initState() {
    super.initState();
    fetchWords();
  }

  Future<void> fetchWords() async {
    final response = await http.get(
        Uri.parse('http://www.good-at-swimming-back.store/words/exam?id=1'));
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      print(data);
      List<Word> fetchedWords = [];
      for (var item in data) {
        fetchedWords.add(
          Word(
            item['voca_id'],
            item['word'],
            item['meaning'],
          ),
        );
      }
      setState(() {
        words = fetchedWords;
      });
    }
  }

  void onWordIncorrect() async {
    Word currentWord = words[current];
    print(currentWord.voca_id);

    final response = await http.post(
      Uri.parse('http://www.good-at-swimming-back.store/words/exam/xbutton/'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'voca': currentWord.voca_id,
      }),
    );

    print("Response status code: ${response.statusCode}");
    print("Response data: ${response.body}");

    if (response.statusCode == 200) {
      print("Word submitted as incorrect.");

      setState(() {
        current++; // 현재 페이지 인덱스를 증가시킴
      });

      carouselController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );

      if (current >= words.length) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ResultPage(),
          ),
        );
      }
    } else {
      print("Failed to submit word as incorrect.");
    }
  }

  void onWordCorrect() async {
    Word currentWord = words[current];
    print(currentWord.voca_id);

    final response = await http.post(
      Uri.parse('http://www.good-at-swimming-back.store/words/exam/check/'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'voca': currentWord.voca_id,
      }),
    );

    print("Response status code: ${response.statusCode}");
    print("Response data: ${response.body}");

    if (response.statusCode == 200) {
      print("Word submitted as incorrect.");

      setState(() {
        current++; // 현재 페이지 인덱스를 증가시킴
      });

      carouselController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );

      if (current >= words.length) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ResultPage(),
          ),
        );
      }
    } else {
      print("Failed to submit word as incorrect.");
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
        title: const Text('VOCA',
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.5,
                fontFamily: 'Player')),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFF030C1A),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CarouselSlider(
            carouselController: carouselController,
            items: words.map((word) {
              return Builder(
                builder: (BuildContext context) {
                  return FlipCard(
                    direction: FlipDirection.HORIZONTAL,
                    front: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(188, 204, 199, 239)),
                      child: Center(
                        child: Text(
                          word.word,
                          style: const TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    back: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(188, 204, 199, 239)),
                      child: Center(
                        child: Text(
                          word.meaning,
                          style: const TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
            options: CarouselOptions(
              height: 500,
              aspectRatio: 16 / 9,
              viewportFraction: 0.8,
              initialPage: 0,
              reverse: false,
              autoPlay: false,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {},
              scrollDirection: Axis.horizontal,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: onWordIncorrect,
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                  elevation: 0,
                ),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                      color: Colors.red, shape: BoxShape.circle),
                  child: const Center(
                    child: Icon(
                      Icons.close,
                      color: Color.fromARGB(188, 204, 199, 239),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 70),
              ElevatedButton(
                onPressed: onWordCorrect,
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                  elevation: 0,
                ),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 92, 101, 187),
                      shape: BoxShape.circle),
                  child: const Center(
                    child: Icon(
                      Icons.check,
                      color: Color.fromARGB(188, 204, 199, 239),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
