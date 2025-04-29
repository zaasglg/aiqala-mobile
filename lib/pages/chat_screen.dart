import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:aiqala/pages/chat_with_ai_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isSearchActive = false; 

  final List<Map<String, String>> _chats = [
    {"name": "ИИ", "message": "Привет! Как я могу помочь?", "time": "Сейчас"},
    {"name": "Nurym", "message": "Привет Ера", "time": "10:30 AM"},
  ];

  Future<void> _refreshChats() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Чат",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(IconlyBroken.search, color: Colors.black),
            onPressed: () {
              setState(() {
                _isSearchActive = !_isSearchActive;
              });
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(IconlyBroken.moreCircle, color: Colors.black),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            color: Colors.white,
            elevation: 4,
            onSelected: (value) {
              if (value == "clear") {
                setState(() {
                  _chats.clear();
                });
                print("Все чаты очищены");
              } else if (value == "settings") {
                print("Настройки чата открыты");
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: "clear",
                child: Row(
                  children: [
                    Icon(IconlyBroken.delete, color: Colors.red),
                    SizedBox(width: 10.0),
                    Text(
                      "Очистить все чаты",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: "settings",
                child: Row(
                  children: [
                    Icon(IconlyBroken.setting, color: Colors.blueAccent),
                    SizedBox(width: 10.0),
                    Text(
                      "Настройки чата",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: _refreshChats, // Trigger refresh
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 8.0),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    "Чат с ИИ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  leading: const CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.greenAccent,
                    child: Icon(
                      IconlyBroken.chat,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    _chats[0]["name"]!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    _chats[0]["message"]!,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    _chats[0]["time"]!,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ChatWithAiScreen(),
                      ),
                    );
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    "Чаты с реальными людьми",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ),
                ..._chats.sublist(1).map((chat) {
                  return Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        leading: CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.blueAccent,
                          child: Text(
                            chat["name"]![0],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        title: Text(
                          chat["name"]!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          chat["message"]!,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(
                          chat["time"]!,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        onTap: () {
                          // Handle real chat tap
                        },
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration:  BoxDecoration(
          color: CupertinoColors.systemBlue,
          borderRadius: BorderRadius.circular(30.0)
          
        ),
        child: IconButton(
          onPressed: () {}, 
          icon: const Icon(IconlyBold.chat, color: Colors.white,)
          ),
      ),
    );
  }
}
