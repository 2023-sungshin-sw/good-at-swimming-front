import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:good_swimming/start_page.dart';
import 'package:good_swimming/tab/home/home_page.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isAllFieldsFilled() {
    return phoneController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty;
  }

  void _showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          width: 311,
          height: 17,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 51, 50, 50),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Center(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Inter',
                fontSize: 12,
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

  void _login() async {
    final String phone = phoneController.text;
    final String password = passwordController.text;

    final Uri uri =
        Uri.parse("http://www.good-at-swimming-back.store/user/login/");
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final String state = data['state'];

      if (state == 'success') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        _showToast(context, "아이디 혹은 비밀번호가 틀렸습니다");
      }
    } else {
      _showToast(context, "로그인에 실패하였습니다.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const StartPage()));
          },
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 5.0),
            Expanded(
              child: Card(
                color: const Color(0xFFD5DBEF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16), // 원하는 둥근 정도 지정
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Welcome back!",
                            style: TextStyle(
                                color: Color(0xFF5C65BB),
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                      // 아이디 입력창과 중복확인 버튼

                      const SizedBox(height: 30.0),

                      const Text(
                        'Phone',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20.0),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextFormField(
                          controller: phoneController,
                          decoration: const InputDecoration(
                            //폰 번호 입력 부분
                            hintText: 'Enter your phone #',
                          ),
                        ),
                      ),

                      const SizedBox(height: 30.0),
                      const Text(
                        'Password',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20.0),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          // 비밀번호 입력 부분
                          decoration: const InputDecoration(
                            hintText: 'Enter your Password',
                          ),
                        ),
                      ),

                      const SizedBox(height: 10.0),
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF5C65BB),
                                fixedSize: Size(200, 50)),
                            onPressed: () {
                              if (isAllFieldsFilled()) {
                                _login();
                              } else {
                                _showToast(context, "모든 칸을 작성해주세요");
                              }
                            },
                            child: const Text(
                              "Log in",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
