import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:aiqala/pages/auth/login_screen.dart';
import 'package:aiqala/services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Profile Header
                Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.blue, width: 2),
                        image: const DecorationImage(
                          image: NetworkImage('https://avatars.mds.yandex.net/i?id=a6f942ad574011fc3bed4124fe516534_l-12475067-images-thumbs&n=13'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Арман Сериков",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22.0,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(IconlyBold.star, color: Colors.amber, size: 16),
                                    SizedBox(width: 5),
                                    Text(
                                      "Эко-саяхатшы",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(IconlyBroken.setting, color: Colors.black54),
                      onPressed: () {
                        _showSettingsDialog(context);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Stats Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatItem(context, "1250", "Баллдар"),
                    Container(height: 40, width: 1, color: Colors.grey.withOpacity(0.3)),
                    _buildStatItem(context, "23", "Челленждер"),
                    Container(height: 40, width: 1, color: Colors.grey.withOpacity(0.3)),
                    _buildStatItem(context, "5", "Деңгей"),
                  ],
                ),

                const SizedBox(height: 30),

                // Progress Section
                const Text(
                  "Деңгей прогресі",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 15),

                LinearPercentIndicator(
                  lineHeight: 15.0,
                  percent: 0.7,
                  backgroundColor: Colors.grey.withOpacity(0.15),
                  progressColor: Colors.blue,
                  barRadius: const Radius.circular(10),
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  center: const Text(
                    "70%",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "1250/1800 баллдар",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      "6-шы деңгейге дейін",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Statistics Section
                const Text(
                  "Статистика",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 15),

                _buildStatisticCard(
                  "Көмірқышқыл газын үнемдеу",
                  "32.5 кг",
                  Icons.eco,
                  Colors.green,
                  0.65,
                ),

                const SizedBox(height: 15),

                _buildStatisticCard(
                  "Су ресурстарын үнемдеу",
                  "125 литр",
                  Icons.water_drop_outlined,
                  Colors.blue,
                  0.45,
                ),

                const SizedBox(height: 15),

                _buildStatisticCard(
                  "Қалдықтарды сұрыптау",
                  "78.3 кг",
                  Icons.delete_outline,
                  Colors.amber,
                  0.82,
                ),

                const SizedBox(height: 30),

                // Achievement Section
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Жетістіктер",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "Барлығы",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildAchievementItem("Эко-белсенді", "1 ай", Icons.park_outlined),
                      _buildAchievementItem("Су үнемдеуші", "2 ай", Icons.water),
                      _buildAchievementItem("Әуесқой велосипедші", "3 ай", Icons.directions_bike),
                      _buildAchievementItem("Қоқыс жинаушы", "2 апта", Icons.delete_sweep),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Settings Dialog
  void _showSettingsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Баптаулар",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.person_outline, color: Colors.blue),
              title: const Text("Профильді өзгерту"),
              onTap: () {
                Navigator.pop(context);
                // Профильді өзгерту функциясы
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_outlined, color: Colors.blue),
              title: const Text("Хабарландырулар"),
              onTap: () {
                Navigator.pop(context);
                // Хабарландырулар функциясы
              },
            ),
            ListTile(
              leading: const Icon(Icons.language_outlined, color: Colors.blue),
              title: const Text("Тіл"),
              trailing: const Text("Қазақша", style: TextStyle(color: Colors.grey)),
              onTap: () {
                Navigator.pop(context);
                // Тіл өзгерту функциясы
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Шығу", style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _showLogoutConfirmation(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Logout Confirmation Dialog
  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Шығу"),
        content: const Text("Жүйеден шығуды растайсыз ба?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Жоқ"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _logout(context);
            },
            child: const Text("Иә", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Logout Function
  void _logout(BuildContext context) async {
    final AuthService authService = AuthService();
    await authService.logout();

    // Navigate to Login Screen and clear the navigation stack
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticCard(
      String title,
      String value,
      IconData icon,
      Color color,
      double percent,
      ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          LinearPercentIndicator(
            lineHeight: 8.0,
            percent: percent,
            backgroundColor: Colors.grey.withOpacity(0.1),
            progressColor: color,
            barRadius: const Radius.circular(5),
            padding: const EdgeInsets.symmetric(horizontal: 0),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "${(percent * 100).toInt()}% орындалды",
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementItem(String title, String subtitle, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(12),
      width: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.blue,
              size: 30,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}