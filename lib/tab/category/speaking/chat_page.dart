import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:good_swimming/tab/category/speaking/feedback_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:good_swimming/tab/category/speaking/speaking_page.dart'; // 추가된 부분
import 'package:speech_to_text/speech_to_text.dart' as stt; // 추가된 부분

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ChatPage(),
    );
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  //final ScrollController _scrollController = ScrollController();
  //final stt.SpeechToText _speech = stt.SpeechToText(); // 음성 인식 객체 추가
  late int _roomId; // 토픽의 id?
  //String chat_room = "2";
  Map<String, String> _questions = {};
  int _currentQuestionIndex = 0; // 현재 보여지는 질문의 인덱스

  @override
  void initState() {
    super.initState();
    _startChat();
  }

  final List<String> _messages = [];

  Future<void> _startChat() async {
    _questions = {};
    try {
      final response = await http.get(
        Uri.parse(
            'http://www.good-at-swimming-back.store/chat/start/theater/1'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        _roomId = data['chat_room_id'];
        _questions = Map<String, String>.from(data['questions']);
        print(_roomId);
        print(_questions);

        setState(() {
          if (_questions.isNotEmpty) {
            _messages.add(
                'Bot: ${_questions.values.elementAt(0)}'); // 봇의 첫 번째 질문을 컨테이너에 추가
          } else {
            _messages.add('Bot: No questions available.');
          }
        });
      } else {
        print('Failed to start chat');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _handleUserResponse() async {
    final userResponse = _messageController.text;

    setState(() {
      _messages.add('You: $userResponse');
    });

    final newChatCom = {
      "chat_room": _roomId.toString(),
      "message": userResponse,
    };

    try {
      final response = await http.post(
        Uri.parse('http://www.good-at-swimming-back.store/chat/reply/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(newChatCom),
      );

      if (response.statusCode == 200) {
        print('데이터를 백엔드로 성공적으로 전송했습니다');
      } else {
        print('데이터 전송 실패. 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      print('데이터를 백엔드로 전송하는 중 오류 발생: $e');
    }
    if (_currentQuestionIndex < _questions.length - 1) {
      // If there are more questions, show the next question
      _currentQuestionIndex++;
      final nextQuestion = _questions.values.elementAt(_currentQuestionIndex);
      _messages.add('Bot: $nextQuestion');
      _messageController.text = '';
    } else {
      // No more questions, chat is done
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FeedbackPage()),
      );
    }
  }

  // void _startListening() async {
  //   bool available = await _speech.initialize();
  //   if (available) {
  //     _speech.listen(
  //       onResult: (result) {
  //         setState(() {
  //           _messageController.text = result.recognizedWords;
  //         });
  //       },
  //     );
  //   } else {
  //     print('음성 인식 사용 권한이 거부되었습니다.');
  //   }
  // }

  // 마이크 버튼 클릭 시 중지 처리
  // void _stopListening() {
  //   _speech.stop();
  // }

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
              MaterialPageRoute(builder: (context) => const SpeakingPage()),
            );
          },
        ),
        title: const Text(
          'TOPIC',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Color(0xFF121F33),
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  if (index < _messages.length) {
                    final message = _messages[index];
                    final isUserMessage = message.startsWith('You:');
                    return _buildMessageBubble(message, isUserMessage);
                  } else if (_questions.isNotEmpty) {
                    final question =
                        _questions.values.elementAt(_currentQuestionIndex);
                    return _buildMessageBubble('Bot: $question', false);
                  } else {
                    return const SizedBox.shrink(); // No more questions to show
                  }
                },
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.mic),
                onPressed: () {
                  //_startListening();
                },
              ), // 마이크 기능 연결 필요
              Expanded(
                child: TextFormField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'Type a message…',
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: () {
                  _handleUserResponse();
                },
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FeedbackPage()),
                  );
                  // 화살표 버튼 클릭 시 처리
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String message, bool isUserMessage) {
    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isUserMessage
              ? const Color(0xFF5C65BB)
              : const Color.fromARGB(255, 132, 134, 136),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class ChatCom {
  final String chat_room;
  final String message;

  ChatCom({
    required this.chat_room,
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'chat_room': chat_room,
      'message': message,
    };
  }

  factory ChatCom.fromJson(Map<String, dynamic> json) {
    return ChatCom(
      chat_room: json['chat_room'],
      message: json['message'],
    );
  }
}
