import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'map_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      const Center(
                        child: Text(
                          "Привет, Я AIQALA",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 26.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Center(
                        child: Text(
                          "Чем я могу вам помочь?",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildActionButton(
                            icon: IconlyBroken.search,
                            label: "Поиск",
                            onTap: () {},
                          ),
                          _buildActionButton(
                            icon: IconlyBroken.chat,
                            label: "Чат",
                            onTap: () {},
                          ),
                          _buildActionButton(
                            icon: IconlyBroken.setting,
                            label: "Настройки",
                            onTap: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildActionButton(
                            icon: IconlyBroken.location,
                            label: "Карта",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const MapScreen()),
                              );
                            },
                          ),
                          _buildActionButton(
                            icon: IconlyBroken.camera,
                            label: "Камера",
                            onTap: () {},
                          ),
                          _buildActionButton(
                            icon: IconlyBroken.activity,
                            label: "Учеба",
                            onTap: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      // Daily Tasks Section
                      const Text(
                        "Ежедневные челенджы",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        margin: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white, // Белый фон
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Image Section
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                                child: Image.network(
                                  'https://avatars.mds.yandex.net/i?id=a6f942ad574011fc3bed4124fe516534_l-12475067-images-thumbs&n=13', // Замените на URL вашего изображения
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Ежедневный челендж",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black, // Черный текст для контраста
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "Один день без пластика",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black54, // Серый текст для описания
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                child: CupertinoButton(
                                  color: CupertinoColors.activeBlue,
                                  onPressed: () {},
                                  child: const Text(
                                    "Принять участие",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
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

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.black87,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
