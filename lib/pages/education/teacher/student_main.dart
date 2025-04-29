import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class Material {
  final String title;
  final String subject;
  final String teacher;
  final String type;
  final String date;
  final String imageUrl;

  Material({
    required this.title,
    required this.subject,
    required this.teacher,
    required this.type,
    required this.date,
    required this.imageUrl,
  });
}

class StudentMain extends StatefulWidget {
  const StudentMain({super.key});

  @override
  State<StudentMain> createState() => _StudentMainState();
}

class _StudentMainState extends State<StudentMain> {
  int _selectedFilterIndex = 0;

  final List<Material> _materials = [
    Material(
      title: "Основы русской грамматики",
      subject: "Русский язык",
      teacher: "Елена Петрова",
      type: "Учебник",
      date: "28 апр",
      imageUrl: "https://randomuser.me/api/portraits/women/44.jpg",
    ),
    Material(
      title: "Алгебраические уравнения",
      subject: "Математика",
      teacher: "Иван Смирнов",
      type: "Упражнения",
      date: "27 апр",
      imageUrl: "https://randomuser.me/api/portraits/men/32.jpg",
    ),
    Material(
      title: "История России XIX века",
      subject: "История",
      teacher: "Ольга Иванова",
      type: "Презентация",
      date: "26 апр",
      imageUrl: "https://randomuser.me/api/portraits/women/68.jpg",
    ),
    Material(
      title: "Эксперименты по химии",
      subject: "Химия",
      teacher: "Алексей Козлов",
      type: "Видеоурок",
      date: "25 апр",
      imageUrl: "https://randomuser.me/api/portraits/men/45.jpg",
    ),
    Material(
      title: "Контрольный тест по литературе",
      subject: "Литература",
      teacher: "Мария Сидорова",
      type: "Тест",
      date: "24 апр",
      imageUrl: "https://randomuser.me/api/portraits/women/22.jpg",
    ),
  ];

  Widget _buildFilterChip(String label, int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: _selectedFilterIndex == index,
        onSelected: (bool selected) {
          if (selected) {
            setState(() {
              _selectedFilterIndex = index;
            });
          }
        },
        backgroundColor: Colors.white,
        selectedColor: const Color(0xFFEEF2FF),
        labelStyle: TextStyle(
          color: _selectedFilterIndex == index
              ? const Color(0xFF4361EE)
              : Colors.grey[600],
          fontWeight: _selectedFilterIndex == index
              ? FontWeight.w600
              : FontWeight.normal,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: _selectedFilterIndex == index
                ? const Color(0xFF4361EE)
                : Colors.grey[300]!,
            width: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3142),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        leading: IconButton(
          icon: const Icon(IconlyBroken.arrowLeft, color: Color(0xFF2D3142)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Ученик",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2D3142),
            letterSpacing: -0.3,
          ),
        ),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(IconlyBroken.notification, color: Color(0xFF2D3142)),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Color(0xFF4361EE),
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              // Handle notifications
            },
          ),
          const SizedBox(width: 8),
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFFEEF2FF),
              backgroundImage: NetworkImage(
                "https://randomuser.me/api/portraits/men/32.jpg",
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Добрый день, Михаил!",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D3142),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Сегодня 29 апреля, вторник",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Stats overview
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            title: "Предметов",
                            value: "7",
                            icon: IconlyBroken.paper,
                            color: const Color(0xFF4361EE),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            title: "Материалов",
                            value: "${_materials.length}",
                            icon: IconlyBroken.document,
                            color: const Color(0xFF3ABFF8),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            title: "Выполнено",
                            value: "73%",
                            icon: IconlyBroken.chart,
                            color: const Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Учебные материалы",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3142),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // View all materials
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF4361EE),
                          ),
                          child: const Row(
                            children: [
                              Text("Все"),
                              SizedBox(width: 4),
                              Icon(IconlyBroken.arrowRight2, size: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Filter tabs
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip("Все", 0),
                      _buildFilterChip("Учебники", 1),
                      _buildFilterChip("Упражнения", 2),
                      _buildFilterChip("Видеоуроки", 3),
                      _buildFilterChip("Тесты", 4),
                    ],
                  ),
                ),
              ),
              // List of study materials
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _materials.length,
                itemBuilder: (context, index) {
                  final material = _materials[index];
                  return MaterialCardStudent(material: material);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show chat with teacher
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Чат с преподавателем"),
              duration: Duration(seconds: 2),
            ),
          );
        },
        backgroundColor: const Color(0xFF4361EE),
        child: const Icon(IconlyBold.chat, color: Colors.white),
      ),
    );
  }
}

class MaterialCardStudent extends StatelessWidget {
  final Material material;

  const MaterialCardStudent({
    Key? key,
    required this.material,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData typeIcon;
    Color typeColor;

    switch (material.type) {
      case "Учебник":
        typeIcon = IconlyBroken.lock;
        typeColor = const Color(0xFF4361EE);
        break;
      case "Упражнения":
        typeIcon = IconlyBroken.paperNegative;
        typeColor = const Color(0xFF10B981);
        break;
      case "Презентация":
        typeIcon = IconlyBroken.image;
        typeColor = const Color(0xFFFF7A50);
        break;
      case "Видеоурок":
        typeIcon = IconlyBroken.video;
        typeColor = const Color(0xFFFF4A6B);
        break;
      case "Тест":
        typeIcon = IconlyBroken.tickSquare;
        typeColor = const Color(0xFF7E57C2);
        break;
      default:
        typeIcon = IconlyBroken.document;
        typeColor = const Color(0xFF4361EE);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // Open material details
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Type icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  typeIcon,
                  color: typeColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      material.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3142),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      material.subject,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 10,
                          backgroundImage: NetworkImage(material.imageUrl),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          material.teacher,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEF2FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            material.date,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF4361EE),
                              fontWeight: FontWeight.w500,
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
      ),
    );
  }
}
