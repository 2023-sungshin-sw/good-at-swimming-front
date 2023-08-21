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
      home: StartPage(),
    );
  }
}

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030C1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF030C1A),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("        Hello Su-Jeong ! \nLet's go to study English",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24)),
            SizedBox(height: 56),
            Container(
              width: 290.19,
              height: 56.37,
              decoration: BoxDecoration(
                  color: Color(0xFF5C65BB),
                  borderRadius: BorderRadius.circular(10)),
              child: const Center(
                child: Text(
                  'Log in',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 19.63),
            Container(
              width: 290.19,
              height: 56.37,
              decoration: BoxDecoration(
                  color: Color(0xFF5C65BB),
                  borderRadius: BorderRadius.circular(10)),
              child: const Center(
                child: Text(
                  'Sign up',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
