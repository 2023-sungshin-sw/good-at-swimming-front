import 'package:flutter/material.dart';
import 'package:good_swimming/tab/category/category_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SpeakingPage(),
    );
  }
}

class SpeakingPage extends StatefulWidget {
  const SpeakingPage({super.key});

  @override
  State<SpeakingPage> createState() => _SpeakingPageState();
}

class _SpeakingPageState extends State<SpeakingPage> {
  bool _isCheckedFirst = false;
  bool _isCheckedSecond = false;
  bool _isCheckedThird = false;
  bool _isCheckedFourth = false;
  bool _isCheckedFifth = false;
  bool _isCheckedSixth = false;
  bool _isCheckedSeventh = false;
  bool _isCheckedEighth = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030C1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF030C1A),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // 메뉴바를 누를 때 CategoryPage로 이동
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CategoryPage()),
            );
          },
        ),
        title: const Text(
          'SPEAKING TOPIC',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 60,
                width: 280,
                decoration: BoxDecoration(
                  color:
                      _isCheckedFirst ? Color(0xFFADADB0) : Color(0xFF121F33),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: const Text(
                    'TOPIC 1',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              Container(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isCheckedFirst = !_isCheckedFirst;
                    });
                  },
                  child: Container(
                    width: 80,
                    height: 60,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: _isCheckedFirst
                            ? Color(0xFF5C65BB)
                            : Color(0xFF5C65BB),
                        border: Border.all(color: Color(0xFF5C65BB), width: 2),
                        borderRadius: BorderRadius.circular(20)),
                    child: _isCheckedFirst
                        ? Icon(Icons.check, size: 30, color: Colors.black)
                        : null,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 60,
                width: 280,
                decoration: BoxDecoration(
                  color:
                      _isCheckedSecond ? Color(0xFFADADB0) : Color(0xFF121F33),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: const Text(
                    'TOPIC 2',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              Container(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isCheckedSecond = !_isCheckedSecond;
                    });
                  },
                  child: Container(
                    width: 80,
                    height: 60,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: _isCheckedSecond
                            ? Color(0xFF5C65BB)
                            : Color(0xFF5C65BB),
                        border: Border.all(color: Color(0xFF5C65BB), width: 2),
                        borderRadius: BorderRadius.circular(20)),
                    child: _isCheckedSecond
                        ? Icon(Icons.check, size: 30, color: Colors.black)
                        : null,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 60,
                width: 280,
                decoration: BoxDecoration(
                  color:
                      _isCheckedThird ? Color(0xFFADADB0) : Color(0xFF121F33),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: const Text(
                    'TOPIC 3',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              Container(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isCheckedThird = !_isCheckedThird;
                    });
                  },
                  child: Container(
                    width: 80,
                    height: 60,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: _isCheckedThird
                            ? Color(0xFF5C65BB)
                            : Color(0xFF5C65BB),
                        border: Border.all(color: Color(0xFF5C65BB), width: 2),
                        borderRadius: BorderRadius.circular(20)),
                    child: _isCheckedThird
                        ? Icon(Icons.check, size: 30, color: Colors.black)
                        : null,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 60,
                width: 280,
                decoration: BoxDecoration(
                  color:
                      _isCheckedFourth ? Color(0xFFADADB0) : Color(0xFF121F33),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: const Text(
                    'TOPIC 4',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              Container(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isCheckedFourth = !_isCheckedFourth;
                    });
                  },
                  child: Container(
                    width: 80,
                    height: 60,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: _isCheckedFourth
                            ? Color(0xFF5C65BB)
                            : Color(0xFF5C65BB),
                        border: Border.all(color: Color(0xFF5C65BB), width: 2),
                        borderRadius: BorderRadius.circular(20)),
                    child: _isCheckedFourth
                        ? Icon(Icons.check, size: 30, color: Colors.black)
                        : null,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 60,
                width: 280,
                decoration: BoxDecoration(
                  color:
                      _isCheckedFifth ? Color(0xFFADADB0) : Color(0xFF121F33),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: const Text(
                    'TOPIC 5',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              Container(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isCheckedFifth = !_isCheckedFifth;
                    });
                  },
                  child: Container(
                    width: 80,
                    height: 60,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: _isCheckedFifth
                            ? Color(0xFF5C65BB)
                            : Color(0xFF5C65BB),
                        border: Border.all(color: Color(0xFF5C65BB), width: 2),
                        borderRadius: BorderRadius.circular(20)),
                    child: _isCheckedFifth
                        ? Icon(Icons.check, size: 30, color: Colors.black)
                        : null,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 60,
                width: 280,
                decoration: BoxDecoration(
                  color:
                      _isCheckedSixth ? Color(0xFFADADB0) : Color(0xFF121F33),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: const Text(
                    'TOPIC 6',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              Container(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isCheckedSixth = !_isCheckedSixth;
                    });
                  },
                  child: Container(
                    width: 80,
                    height: 60,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: _isCheckedSixth
                            ? Color(0xFF5C65BB)
                            : Color(0xFF5C65BB),
                        border: Border.all(color: Color(0xFF5C65BB), width: 2),
                        borderRadius: BorderRadius.circular(20)),
                    child: _isCheckedSixth
                        ? Icon(Icons.check, size: 30, color: Colors.black)
                        : null,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 60,
                width: 280,
                decoration: BoxDecoration(
                  color:
                      _isCheckedSeventh ? Color(0xFFADADB0) : Color(0xFF121F33),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: const Text(
                    'TOPIC 7',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              Container(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isCheckedSeventh = !_isCheckedSeventh;
                    });
                  },
                  child: Container(
                    width: 80,
                    height: 60,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: _isCheckedSeventh
                            ? Color(0xFF5C65BB)
                            : Color(0xFF5C65BB),
                        border: Border.all(color: Color(0xFF5C65BB), width: 2),
                        borderRadius: BorderRadius.circular(20)),
                    child: _isCheckedSeventh
                        ? Icon(Icons.check, size: 30, color: Colors.black)
                        : null,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 60,
                width: 280,
                decoration: BoxDecoration(
                  color:
                      _isCheckedEighth ? Color(0xFFADADB0) : Color(0xFF121F33),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: const Text(
                    'TOPIC 8',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              Container(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isCheckedEighth = !_isCheckedEighth;
                    });
                  },
                  child: Container(
                    width: 80,
                    height: 60,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: _isCheckedEighth
                            ? Color(0xFF5C65BB)
                            : Color(0xFF5C65BB),
                        border: Border.all(color: Color(0xFF5C65BB), width: 2),
                        borderRadius: BorderRadius.circular(20)),
                    child: _isCheckedEighth
                        ? Icon(Icons.check, size: 30, color: Colors.black)
                        : null,
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
