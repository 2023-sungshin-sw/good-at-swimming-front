import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:good_swimming/start_page.dart';
import 'package:http/http.dart' as http;

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool passwordsMatch = true;
  bool isUsernameAvailable = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordC_Controller = TextEditingController();

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
                fontFamily: 'Kr',
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

  Future<void> checkPhoneNumberAvailability() async {
    final String phoneNumber = phoneController.text;

    final Uri uri =
        Uri.parse('http://www.good-at-swimming-back.store/user/check-phone/');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phoneNumber}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final isvalid = data['is_valid'] as bool;

      setState(() {
        isUsernameAvailable = isvalid;
      });

      if (!isvalid) {
        _showToast(context, "이미 사용 중인 전화번호입니다.");
      } else {
        print('Failed to send data. Status code: ${response.statusCode}');
      }
    }
  }

  Future<void> sendDataToBackend() async {
    final String name = nameController.text;
    final String phone = phoneController.text;
    final String password = passwordController.text;

    final Uri uri =
        Uri.parse('http://www.good-at-swimming-back.store/user/join/');
    final Information = informationData(
      name: name,
      phone: phone,
      password: password,
    );

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(Information.toJson()),
      );

      if (response.statusCode == 201) {
        // 요청이 성공한 경우
        print('Data sent successfully');
        _showToast(context, "회원가입이 완료되었습니다!");
      } else {
        // 요청이 실패한 경우
        print('Failed to send data. Status code: ${response.statusCode}');
        _showToast(context, "회원가입에 실패하였습니다.");
      }
    } catch (e) {
      print('Error sending data: $e');
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
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 5.0),
            Expanded(
              child: Card(
                color: const Color(0xFFD5DBEF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Let's GO!",
                              style: TextStyle(
                                  color: Color(0xFF5C65BB),
                                  fontSize: 27.9,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'En'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        const Text(
                          'English Name',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'En'),
                        ),
                        const SizedBox(height: 10.0),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextFormField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              hintText: 'Enter your English name',
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Phone',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'En'),
                            ),
                            const SizedBox(height: 10.0),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: TextFormField(
                                      controller: phoneController,
                                      decoration: const InputDecoration(
                                        hintText: 'Enter your phone #',
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                  width: 85,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (phoneController.text.isEmpty) {
                                        _showToast(context, "전화번호를 입력해주세요");
                                      } else if (!isUsernameAvailable) {
                                        setState(() {
                                          isUsernameAvailable =
                                              !isUsernameAvailable;
                                        });

                                        if (isUsernameAvailable) {
                                          _showToast(
                                              context, "사용 가능한 전화번호입니다.");
                                        } else {
                                          _showToast(
                                              context, "이미 사용 중인 전화번호입니다.");
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF5C65BB),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        isUsernameAvailable
                                            ? const Icon(Icons.check,
                                                color: Colors
                                                    .white) // 중복확인이 확인 아이콘으로 변경
                                            : const Text(
                                                '중복확인',
                                                style: TextStyle(
                                                  fontFamily: 'Kr',
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        const Text(
                          'Password',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'En'),
                        ),
                        const SizedBox(height: 10.0),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextFormField(
                            controller: passwordController,
                            decoration: const InputDecoration(
                              hintText: 'Enter your Password',
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        const Text(
                          'Confirm Password',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'En'),
                        ),
                        const SizedBox(height: 10.0),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextFormField(
                            controller: passwordC_Controller,
                            decoration: const InputDecoration(
                              hintText: 'Enter your Password again',
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
                                  fixedSize: Size(200, 35)),
                              onPressed: () async {
                                if (nameController.text == null ||
                                    nameController.text.isEmpty) {
                                  _showToast(context, "이름을 입력해주세요");
                                } else if (phoneController.text == null ||
                                    phoneController.text.isEmpty) {
                                  _showToast(context, "전화번호를 입력해주세요");
                                } else if (!isUsernameAvailable) {
                                  _showToast(context, "전화번호 중복확인을 해주세요");
                                } else if (passwordC_Controller.text == null ||
                                    passwordC_Controller.text.isEmpty) {
                                  _showToast(context, "비밀번호를 확인해주세요");
                                } else if (passwordController.text !=
                                    passwordC_Controller.text) {
                                  setState(() {
                                    passwordsMatch = false;
                                  });
                                  _showToast(context, "비밀번호가 일치하지 않습니다");
                                } else {
                                  passwordsMatch = true;
                                  await checkPhoneNumberAvailability();
                                }
                                if (isUsernameAvailable) {
                                  sendDataToBackend();
                                }
                              },
                              child: const Text(
                                "SIGN UP",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'En'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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

class informationData {
  final String name;
  final String phone;
  final String password;

  informationData({
    required this.name,
    required this.phone,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'password': password,
    };
  }

  factory informationData.fromJson(Map<String, dynamic> json) {
    return informationData(
      name: json['name'],
      phone: json['phone'],
      password: json['password'],
    );
  }
}
