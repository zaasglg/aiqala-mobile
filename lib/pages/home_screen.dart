import 'package:aiqala/pages/chat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();

  // Контроллер анимации для эффекта обновления
  late AnimationController _refreshAnimationController;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _refreshAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _refreshAnimationController.dispose();
    super.dispose();
  }

  // Метод для показа модального диалога поиска
  void _showSearchModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: Column(
              children: [
                // Индикатор перетаскивания
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  height: 5,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                const SizedBox(height: 16),

                // Заголовок и кнопка закрытия
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Поиск",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF212529),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, color: Color(0xFF6B7280)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Поле поиска
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: "Что вы ищете?",
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      prefixIcon: const Icon(IconlyLight.search,
                          color: Color(0xff003092)),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear,
                                  color: Color(0xFF6B7280)),
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                });
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: const Color(0xFFF8F9FA),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Подсказки для поиска
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Популярные запросы",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF212529),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSearchSuggestion("Экологические проекты"),
                      _buildSearchSuggestion("Студенческие мероприятия"),
                      _buildSearchSuggestion("Расписание занятий"),
                      _buildSearchSuggestion("Библиотека"),
                      _buildSearchSuggestion("Спортивные секции"),
                    ],
                  ),
                ),

                // Здесь можно добавить результаты поиска, если необходимо
                if (_searchController.text.isNotEmpty)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Результаты",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF212529),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: ListView.builder(
                              itemCount: 1,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: const Color(0xff003092)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      IconlyBold.search,
                                      color: Color(0xff003092),
                                    ),
                                  ),
                                  title: Text(
                                    "Поиск: ${_searchController.text}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "Нажмите, чтобы найти \"${_searchController.text}\"",
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  onTap: () {
                                    // Здесь будет логика поиска
                                    Navigator.pop(context);
                                    // Можно также передать результат поиска или выполнить действие
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Метод для обработки обновления
  Future<void> _handleRefresh() async {
    // Начинаем анимацию
    setState(() {
      _isRefreshing = true;
    });
    _refreshAnimationController.repeat();

    // Имитируем загрузку данных
    await Future.delayed(const Duration(seconds: 2));

    // Останавливаем анимацию
    _refreshAnimationController.stop();
    setState(() {
      _isRefreshing = false;
    });

    // Можно добавить логику обновления данных
    return Future.value();
  }

  // Виджет для отображения подсказки поиска
  Widget _buildSearchSuggestion(String suggestion) {
    return GestureDetector(
      onTap: () {
        _searchController.text = suggestion;
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(
              IconlyLight.timeCircle,
              color: Color(0xFF6B7280),
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              suggestion,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
            const Spacer(),
            const Icon(
              IconlyLight.arrowRight,
              color: Color(0xFF6B7280),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                color: const Color(0xff003092),
                backgroundColor: Colors.white,
                displacement: 120, // Высота для нашего кастомного индикатора
                // Кастомный индикатор обновления
                notificationPredicate: (notification) {
                  // Показываем наш кастомный индикатор только при активном обновлении
                  return notification.depth == 0;
                },
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    // Основной контент
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          // Header Section with Gradient
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 24),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xff003092).withOpacity(0.7),
                                  const Color(0xff003092).withOpacity(0.8),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xff003092).withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 32, horizontal: 28),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.white
                                                .withOpacity(0.2),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            IconlyBold.voice,
                                            color: Colors.white,
                                            size: 28,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        const Text(
                                          "AIQALA",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 24.0,
                                            color: Colors.white,
                                            letterSpacing: 1,
                                            fontFamily: "dusha"
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 24),
                                    const Text(
                                      "Привет!",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 32.0,
                                          color: Colors.white,
                                          height: 1.1,
                                          
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Чем я могу вам помочь?",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18.0,
                                        color:
                                            Colors.white.withOpacity(0.9),
                                        height: 1.4,
                                      ),
                                    ),
                                    const SizedBox(height: 32),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16, horizontal: 20),
                                      decoration: BoxDecoration(
                                        color:
                                            Colors.white.withOpacity(0.15),
                                        borderRadius:
                                            BorderRadius.circular(16),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "Задайте ваш вопрос...",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16.0,
                                                color: Colors.white
                                                    .withOpacity(0.8),
                                              ),
                                            ),
                                          ),
                                          Icon(
                                            IconlyBold.send,
                                            color: Colors.white
                                                .withOpacity(0.9),
                                            size: 24,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Action Buttons with improved styling
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildActionButton(
                                    icon: IconlyBroken.search,
                                    label: "Поиск",
                                    onTap: _showSearchModal,
                                    color: Color(0xff003092),
                                  ),
                                  _buildActionButton(
                                    icon: IconlyBroken.chat,
                                    label: "Чат",
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const ChatScreen(),
                                        ),
                                      );
                                    },
                                    color: Color(0xff003092),
                                  ),
                                  _buildActionButton(
                                    icon: IconlyBroken.setting,
                                    label: "Настройки",
                                    onTap: () {},
                                    color: Color(0xff003092),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildActionButton(
                                    icon: IconlyBroken.location,
                                    label: "Карта",
                                    onTap: () {},
                                    color: Color(0xff003092),
                                  ),
                                  _buildActionButton(
                                    icon: IconlyBroken.camera,
                                    label: "Камера",
                                    onTap: () {},
                                    color: Color(0xff003092),
                                  ),
                                  _buildActionButton(
                                    icon: IconlyBroken.activity,
                                    label: "Учеба",
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const ChatScreen(),
                                        ),
                                      );
                                    },
                                    color: Color(0xff003092),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),

                          // Daily Tasks Section with improved styling
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Ежедневные челенджы",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF212529),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    "Все",
                                    style: TextStyle(
                                      color: Color(0xff003092),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Challenge Card
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Image with Overlay
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                      child: Image.network(
                                        'https://avatars.mds.yandex.net/i?id=3ca6ea1c6467a5214c0a5e184b370dae_l-5513171-images-thumbs&n=13',
                                        height: 200,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 16,
                                      right: 16,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: const Color(0xff003092),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: const Text(
                                          "Эко-челендж",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Один день без пластика",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF212529),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        "Присоединяйтесь к челенджу и помогите сохранить природу",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF6B7280),
                                          height: 1.5,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color(0xff003092),
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 16),
                                                elevation: 0,
                                              ),
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
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ],
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
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: CupertinoColors.systemGrey5, // Gray border color
                width: 1.5, // Border width
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: 30,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: CupertinoColors.systemGrey2,
              fontFamily: "avenir",
            ),
          ),
        ],
      ),
    );
  }
}
