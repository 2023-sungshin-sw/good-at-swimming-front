import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flip_card/flip_card.dart';
import 'package:good_swimming/tab/category/word/word_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Word {
  final String english;
  final String Korean;

  Word({required this.english, required this.Korean});
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TestPage(),
    );
  }
}

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final CarouselController carouselController = CarouselController();
  List<Word> words = [
    Word(english: 'Professor', Korean: '교수'),
    Word(english: 'Student', Korean: '학생'),
    Word(english: 'Time', Korean: '시간'),
  ];
  int current = 0;

  @override
  void initState() {
    super.initState();
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
                          word.english,
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
                          word.Korean,
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
                onPressed: () => carouselController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.linear),
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
                onPressed: () => carouselController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.linear),
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                  elevation: 0,
                ),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 92, 101, 187),
                      shape: BoxShape.circle),
                  child: Center(
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
