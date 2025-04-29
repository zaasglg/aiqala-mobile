import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class ChatItem {
  final String id;
  final String title;
  final DateTime timestamp;
  final List<ChatMessage> messages;

  ChatItem({
    required this.id,
    required this.title,
    required this.timestamp,
    required this.messages,
  });

  factory ChatItem.create(String firstMessageText) {
    final title = firstMessageText.length > 30
        ? '${firstMessageText.substring(0, 30)}...'
        : firstMessageText;
    return ChatItem(
      id: const Uuid().v4(),
      title: title,
      timestamp: DateTime.now(),
      messages: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'timestamp': timestamp.toIso8601String(),
      'messages': messages.map((msg) => msg.toJson()).toList(),
    };
  }

  factory ChatItem.fromJson(Map<String, dynamic> json) {
    return ChatItem(
      id: json['id'],
      title: json['title'],
      timestamp: DateTime.parse(json['timestamp']),
      messages: (json['messages'] as List)
          .map((msg) => ChatMessage.fromJson(msg))
          .toList(),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? imagePath;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.imagePath,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'imagePath': imagePath,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      text: json['text'],
      isUser: json['isUser'],
      timestamp: DateTime.parse(json['timestamp']),
      imagePath: json['imagePath'],
    );
  }
}

class ObjectDetectorScreen extends StatefulWidget {
  const ObjectDetectorScreen({super.key});

  @override
  State<ObjectDetectorScreen> createState() => _ObjectDetectorScreenState();
}

class _ObjectDetectorScreenState extends State<ObjectDetectorScreen> {
  final ImagePicker _picker = ImagePicker();
  String? _apiResponse;
  bool _isLoading = false;
  String? _errorMessage;
  File? _selectedImage;

  // Чат жүйесі үшін қажетті айнымалылар
  List<ChatItem> _chatHistory = [];
  ChatItem? _currentChat;
  TextEditingController _promptController = TextEditingController();
  bool _isChatHistoryVisible = false;

  // API Конфигурациясы
  final String _apiKey = "AIzaSyDYgxAqt5g6xvJkOomVCWDXhHo8DYYJ3M4"; // Өз API кілтіңізді қойыңыз
  final String _apiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent";

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
  }

  // Чат тарихын жүктеу
  Future<void> _loadChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final chatHistoryJson = prefs.getStringList('chat_history') ?? [];

    setState(() {
      _chatHistory = chatHistoryJson
          .map((chat) => ChatItem.fromJson(jsonDecode(chat)))
          .toList();

      // Чаттарды уақыт бойынша сұрыптау
      _chatHistory.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    });
  }

  // Чат тарихын сақтау
  Future<void> _saveChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final chatHistoryJson = _chatHistory
        .map((chat) => jsonEncode(chat.toJson()))
        .toList();

    await prefs.setStringList('chat_history', chatHistoryJson);
  }

  // Жаңа чат бастау
  void _startNewChat() {
    setState(() {
      _currentChat = ChatItem.create('Жаңа чат');
      _chatHistory.insert(0, _currentChat!);
      _apiResponse = null;
      _errorMessage = null;
      _selectedImage = null;
      _isChatHistoryVisible = false;
    });

    _saveChatHistory();
  }

  // Чатты ашу
  void _openChat(ChatItem chat) {
    setState(() {
      _currentChat = chat;
      _apiResponse = chat.messages.isNotEmpty
          ? chat.messages.last.isUser ? null : chat.messages.last.text
          : null;
      _selectedImage = null;
      _errorMessage = null;
      _isChatHistoryVisible = false;

      // Егер чатта сурет болса, оны көрсету
      if (chat.messages.isNotEmpty && chat.messages.last.imagePath != null) {
        _selectedImage = File(chat.messages.last.imagePath!);
      }
    });
  }

  // Чатты жою
  void _deleteChat(ChatItem chat) {
    setState(() {
      _chatHistory.remove(chat);
      if (_currentChat?.id == chat.id) {
        _currentChat = null;
        _apiResponse = null;
        _selectedImage = null;
      }
    });

    _saveChatHistory();
  }

  // Хабарлама қосу
  void _addMessage(String text, bool isUser, {String? imagePath}) {
    if (_currentChat == null) {
      // Егер ағымдағы чат болмаса, жаңа чат бастаймыз
      _startNewChat();
    }

    final message = ChatMessage(
      text: text,
      isUser: isUser,
      timestamp: DateTime.now(),
      imagePath: imagePath,
    );

    setState(() {
      _currentChat!.messages.add(message);
    });

    _saveChatHistory();
  }

  Future<void> _pickAndAnalyzeImage() async {
    setState(() {
      _isLoading = true;
      _apiResponse = null;
      _errorMessage = null;
    });

    try {
      // Галереядан сурет алу
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final imageFile = File(pickedFile.path);
        setState(() {
          _selectedImage = imageFile;
        });

        // Промпт мәтінін алу
        String prompt = _promptController.text.isEmpty
            ? "Суреттегі зат туралы анықтама, қауіптілігі, қайта өңделема"
            : _promptController.text;

        // Пайдаланушы хабарламасын қосу
        _addMessage(prompt, true, imagePath: pickedFile.path);
        _promptController.clear();

        // Суретті base64 форматына аудару
        final List<int> imageBytes = await imageFile.readAsBytes();
        final String base64Image = base64Encode(imageBytes);

        // Gemini API-ға сұрау жіберу
        await _callGeminiApi(base64Image, prompt);

      } else {
        // Пайдаланушы сурет таңдаудан бас тартты
        setState(() {
          _errorMessage = "Галереядан сурет таңдалмады.";
        });
      }
    } catch (e) {
      print("Қате пайда болды: $e");
      setState(() {
        _errorMessage = "Суретті өңдеу кезінде қате пайда болды: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _callGeminiApi(String base64Image, String prompt) async {
    final requestBody = jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": prompt},
            {
              "inline_data": {
                "mime_type": "image/jpeg",
                "data": base64Image
              }
            }
          ]
        }
      ],
    });

    try {
      final response = await http.post(
        Uri.parse("$_apiUrl?key=$_apiKey"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        final candidates = decodedResponse['candidates'] as List<dynamic>?;
        if (candidates != null && candidates.isNotEmpty) {
          final content = candidates[0]['content'] as Map<String, dynamic>?;
          if (content != null) {
            final parts = content['parts'] as List<dynamic>?;
            if (parts != null && parts.isNotEmpty) {
              final text = parts[0]['text'] as String?;
              if (text != null) {
                setState(() {
                  _apiResponse = text;
                  _errorMessage = null;
                });

                // AI жауабын чатқа қосу
                _addMessage(text, false);
                return;
              }
            }
          }
        }
        throw Exception("API жауабынан мәтінді алу мүмкін болмады.");

      } else {
        print("API қатесі: ${response.statusCode}");
        print("Жауап: ${response.body}");
        final errorBody = jsonDecode(utf8.decode(response.bodyBytes));
        final errorMessage = errorBody['error']?['message'] ?? 'Белгісіз API қатесі';
        throw Exception("API қатесі (${response.statusCode}): $errorMessage");
      }
    } catch (e) {
      print("API сұрауы кезінде қате: $e");
      setState(() {
        _errorMessage = "API-ға сұрау жіберу кезінде қате: $e";
        _apiResponse = null;
      });

      // Қате туралы хабарлама чатқа қосу
      _addMessage("Қате пайда болды: $_errorMessage", false);
    }
  }

  // Сұрау жіберу батырмасын басқанда орындалатын функция
  void _handleSubmit() {
    if (_selectedImage != null) {
      if (_promptController.text.isNotEmpty) {
        final prompt = _promptController.text;
        _pickAndAnalyzeImage();
      } else {
        setState(() {
          _errorMessage = "Сұрау мәтінін енгізіңіз";
        });
      }
    } else {
      _pickAndAnalyzeImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Объектіні Анықтау'),
        actions: [
          IconButton(
            icon: Icon(_isChatHistoryVisible ? Icons.close : Icons.history),
            onPressed: () {
              setState(() {
                _isChatHistoryVisible = !_isChatHistoryVisible;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _startNewChat,
          ),
        ],
      ),
      body: _isChatHistoryVisible
          ? _buildChatHistoryView()
          : _buildMainView(),
    );
  }

  // Чат тарихын көрсететін виджет
  Widget _buildChatHistoryView() {
    return _chatHistory.isEmpty
        ? const Center(
      child: Text(
        'Чат тарихы бос',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    )
        : ListView.builder(
      itemCount: _chatHistory.length,
      itemBuilder: (context, index) {
        final chat = _chatHistory[index];
        final formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(chat.timestamp);

        return Dismissible(
          key: Key(chat.id),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Чатты жою'),
                  content: const Text('Бұл чатты шынымен жойғыңыз келе ме?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Жоқ'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Иә'),
                    ),
                  ],
                );
              },
            );
          },
          onDismissed: (direction) {
            _deleteChat(chat);
          },
          child: ListTile(
            title: Text(
              chat.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(formattedDate),
            leading: const CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.chat, color: Colors.white),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _openChat(chat),
          ),
        );
      },
    );
  }

  // Негізгі экранды көрсететін виджет
  Widget _buildMainView() {
    return Column(
      children: [
        Expanded(
          child: _currentChat == null || _currentChat!.messages.isEmpty
              ? _buildEmptyStateView()
              : _buildChatView(),
        ),
        _buildInputArea(),
      ],
    );
  }

  // Бос күй виджеті
  Widget _buildEmptyStateView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.image_search,
            size: 80,
            color: Colors.blue,
          ),
          const SizedBox(height: 20),
          const Text(
            'Объектіні анықтау үшін төменде сурет таңдаңыз',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              textStyle: const TextStyle(fontSize: 16),
            ),
            onPressed: _isLoading ? null : _pickAndAnalyzeImage,
            icon: const Icon(Icons.photo_library_outlined),
            label: const Text('Галереядан Таңдау'),
          ),
        ],
      ),
    );
  }

  // Чат көрінісі виджеті
  Widget _buildChatView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      itemCount: _currentChat!.messages.length,
      itemBuilder: (context, index) {
        final message = _currentChat!.messages[index];

        return _buildMessageBubble(message, index);
      },
    );
  }

  // Хабарлама көпіршігі виджеті
  Widget _buildMessageBubble(ChatMessage message, int index) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          crossAxisAlignment: message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Егер сурет болса, оны көрсету
            if (message.imagePath != null && message.isUser)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(message.imagePath!),
                    height: 150,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser ? Colors.blue : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : Colors.black,
                  fontSize: 15,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
              child: Text(
                DateFormat('HH:mm').format(message.timestamp),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Енгізу аймағы виджеті
  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Галерея батырмасы
          IconButton(
            icon: const Icon(Icons.photo_library, color: Colors.blue),
            onPressed: _isLoading ? null : _pickAndAnalyzeImage,
          ),
          // Мәтін енгізу өрісі
          Expanded(
            child: TextField(
              controller: _promptController,
              decoration: InputDecoration(
                hintText: 'Сұрау мәтінін енгізіңіз...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                isDense: true,
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _handleSubmit(),
            ),
          ),
          const SizedBox(width: 8),
          // Жіберу батырмасы
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: _isLoading ? null : _handleSubmit,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }
}