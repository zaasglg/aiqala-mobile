import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:http/http.dart' as http;

class ChatWithAiScreen extends StatefulWidget {
  const ChatWithAiScreen({super.key});

  @override
  State<ChatWithAiScreen> createState() => _ChatWithAiScreenState();
}

class _ChatWithAiScreenState extends State<ChatWithAiScreen> {
  final List<Map<String, String>> _messages = [
    {"sender": "ИИ", "text": "Привет! Как я могу помочь?"},
  ];

  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  Future<void> _sendMessage() async {
    if (_controller.text.trim().isNotEmpty) {
      final userMessage = _controller.text.trim();
      setState(() {
        _messages.add({"sender": "Вы", "text": userMessage});
        _controller.clear();
        _isLoading = true;
      });

      try {
        // Отправка запроса к ChatGPT API
        final response = await http.post(
          Uri.parse("https://api.openai.com/v1/chat/completions"),
          headers: {
            "Content-Type": "application/json",
            "Authorization":
                "Bearer API_ENV",
          },
          body: jsonEncode({
            "model": "gpt-4o-mini",
            "messages": [
              {"role": "user", "content": userMessage},
            ],
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final aiMessage = data["choices"][0]["message"]["content"];
          setState(() {
            _messages.add({"sender": "ИИ", "text": aiMessage});
          });
        } else {
          setState(() {
            _messages.add({
              "sender": "ИИ",
              "text": "Ошибка: не удалось получить ответ от ChatGPT."
            });
          });
        }
      } catch (e) {
        setState(() {
          _messages.add({
            "sender": "ИИ",
            "text": "Ошибка: проверьте подключение к интернету."
          });
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(IconlyBroken.arrowLeft, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Чат с ИИ",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: ListView.builder(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              itemCount: _messages.length +
                  (_isLoading ? 1 : 0), // Add extra item for loading
              itemBuilder: (context, index) {
                if (index == _messages.length && _isLoading) {
                  // Show loading indicator for AI response
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      child: const CupertinoActivityIndicator(),
                    ),
                  );
                }

                final message = _messages[index];
                final isUser = message["sender"] == "Вы";
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blueAccent : Colors.grey[300],
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12.0),
                        topRight: const Radius.circular(12.0),
                        bottomLeft:
                            isUser ? const Radius.circular(12.0) : Radius.zero,
                        bottomRight:
                            isUser ? Radius.zero : const Radius.circular(12.0),
                      ),
                    ),
                    child: Text(
                      message["text"]!,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Input field
          Container(
            padding: const EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 25.0),
            decoration: const BoxDecoration(color: Colors.white),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Введите сообщение...",
                      prefixIcon:
                          const Icon(IconlyBroken.edit, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14.0,
                        horizontal: 16.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(IconlyBroken.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
