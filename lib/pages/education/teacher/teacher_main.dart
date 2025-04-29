import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'dart:ui';

class TeacherMain extends StatefulWidget {
  const TeacherMain({super.key});

  @override
  State<TeacherMain> createState() => _TeacherMainState();
}

class _TeacherMainState extends State<TeacherMain> {
  // Dummy data for teaching materials
  final List<TeachingMaterial> _materials = [
    TeachingMaterial(
      title: "Введение в математику",
      description:
          "Базовые концепции для начинающих. Включает интерактивные упражнения и примеры для лучшего усвоения материала.",
      date: "25 апреля 2025",
      type: "Учебник",
      students: 28,
      progress: 0.75,
    ),
    TeachingMaterial(
      title: "Упражнения по алгебре",
      description:
          "Сборник задач для самостоятельной работы. Содержит решения и методические указания для учителей.",
      date: "22 апреля 2025",
      type: "Упражнения",
      students: 32,
      progress: 0.45,
    ),
    TeachingMaterial(
      title: "Основы геометрии",
      description:
          "Видеоуроки и практические задания с интерактивными моделями геометрических фигур.",
      date: "18 апреля 2025",
      type: "Видеоурок",
      students: 24,
      progress: 0.60,
    ),
  ];

  int _selectedIndex = 0;

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
          "Учитель",
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
                "https://randomuser.me/api/portraits/women/44.jpg",
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
                              "Добрый день, Елена!",
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
                            title: "Материалы",
                            value: "${_materials.length}",
                            icon: IconlyBroken.document,
                            color: const Color(0xFF4361EE),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            title: "Студенты",
                            value: "84",
                            icon: IconlyBroken.user3,
                            color: const Color(0xFF3ABFF8),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            title: "Активность",
                            value: "68%",
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
              // List of teaching materials
              ListView.builder(
                shrinkWrap: true, // Ограничиваем высоту списка
                physics:
                    const NeverScrollableScrollPhysics(), // Отключаем прокрутку
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _materials.length,
                itemBuilder: (context, index) {
                  final material = _materials[index];
                  return MaterialCard(material: material);
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: IconButton(
        onPressed: () {
          _showCreateMaterialDialog(context);
        },
        icon: const Icon(IconlyBold.plus, size: 20),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4361EE),
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
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
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3142),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: _selectedIndex == index,
        onSelected: (bool selected) {
          if (selected) {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
        backgroundColor: Colors.white,
        selectedColor: const Color(0xFFEEF2FF),
        labelStyle: TextStyle(
          color: _selectedIndex == index
              ? const Color(0xFF4361EE)
              : Colors.grey[600],
          fontWeight: _selectedIndex == index
              ? FontWeight.w600
              : FontWeight.normal,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: _selectedIndex == index
                ? const Color(0xFF4361EE)
                : Colors.grey[300]!,
            width: 1,
          ),
        ),
      ),
    );
  }

  void _showCreateMaterialDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String title = '';
    String description = '';
    String type = 'Учебник';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Новый материал",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3142),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Название",
                      hintText: "Введите название материала",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF4361EE),
                          width: 2,
                        ),
                      ),
                      prefixIcon: const Icon(IconlyBroken.document),
                      floatingLabelStyle: const TextStyle(
                        color: Color(0xFF4361EE),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, введите название';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      title = value;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Описание",
                      hintText: "Опишите содержание материала",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF4361EE),
                          width: 2,
                        ),
                      ),
                      prefixIcon: const Icon(IconlyBroken.edit),
                      floatingLabelStyle: const TextStyle(
                        color: Color(0xFF4361EE),
                      ),
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, введите описание';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      description = value;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Тип материала",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF4361EE),
                          width: 2,
                        ),
                      ),
                      prefixIcon: const Icon(IconlyBroken.category),
                      floatingLabelStyle: const TextStyle(
                        color: Color(0xFF4361EE),
                      ),
                    ),
                    value: type,
                    items: const [
                      DropdownMenuItem(
                          value: "Учебник", child: Text("Учебник")),
                      DropdownMenuItem(
                          value: "Упражнения", child: Text("Упражнения")),
                      DropdownMenuItem(
                          value: "Видеоурок", child: Text("Видеоурок")),
                      DropdownMenuItem(value: "Тест", child: Text("Тест")),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        type = value;
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  // File upload section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4361EE).withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                IconlyBroken.upload,
                                color: Color(0xFF4361EE),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Прикрепить файлы",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "PDF, DOCX, PPTX до 10MB",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
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
                  const SizedBox(height: 24),
                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          // Add new material
                          setState(() {
                            _materials.add(
                              TeachingMaterial(
                                title: title,
                                description: description,
                                date: "29 апреля 2025",
                                type: type,
                                students: 0,
                                progress: 0.0,
                              ),
                            );
                          });
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4361EE),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Создать материал",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
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
    );
  }
}

// Model class for teaching material
class TeachingMaterial {
  final String title;
  final String description;
  final String date;
  final String type;
  final int students;
  final double progress;

  TeachingMaterial({
    required this.title,
    required this.description,
    required this.date,
    required this.type,
    required this.students,
    required this.progress,
  });
}

// Card widget for displaying a teaching material
class MaterialCard extends StatelessWidget {
  final TeachingMaterial material;

  const MaterialCard({super.key, required this.material});

  Color _getTypeColor() {
    switch (material.type) {
      case "Учебник":
        return const Color(0xFF4361EE);
      case "Упражнения":
        return const Color(0xFF10B981);
      case "Видеоурок":
        return const Color(0xFFF59E0B);
      case "Тест":
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF4361EE);
    }
  }

  IconData _getTypeIcon() {
    switch (material.type) {
      case "Учебник":
        return IconlyBroken.document;
      case "Упражнения":
        return IconlyBroken.paper;
      case "Видеоурок":
        return IconlyBroken.play;
      case "Тест":
        return IconlyBroken.tickSquare;
      default:
        return IconlyBroken.document;
    }
  }

  @override
  Widget build(BuildContext context) {
    final typeColor = _getTypeColor();

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
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: typeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getTypeIcon(),
                        color: typeColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            material.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3142),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: typeColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  material.type,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: typeColor,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                IconlyBroken.timeCircle,
                                size: 14,
                                color: Colors.grey[500],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                material.date,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: Icon(
                        IconlyBroken.moreCircle,
                        color: Colors.grey[700],
                      ),
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: "edit",
                          child: Row(
                            children: [
                              Icon(IconlyBroken.edit, size: 18),
                              SizedBox(width: 8),
                              Text("Редактировать"),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: "duplicate",
                          child: Row(
                            children: [
                              Icon(IconlyBroken.paper, size: 18),
                              SizedBox(width: 8),
                              Text("Дублировать"),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: "delete",
                          child: Row(
                            children: [
                              Icon(IconlyBroken.delete,
                                  size: 18, color: Colors.red),
                              SizedBox(width: 8),
                              Text("Удалить",
                                  style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        // Handle actions
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  material.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      IconlyBroken.user3,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "${material.students} студентов",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Прогресс",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                "${(material.progress * 100).toInt()}%",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: material.progress > 0.7
                                      ? const Color(0xFF10B981)
                                      : material.progress > 0.3
                                          ? const Color(0xFFF59E0B)
                                          : const Color(0xFFEF4444),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: material.progress,
                              backgroundColor: Colors.grey[200],
                              color: material.progress > 0.7
                                  ? const Color(0xFF10B981)
                                  : material.progress > 0.3
                                      ? const Color(0xFFF59E0B)
                                      : const Color(0xFFEF4444),
                              minHeight: 6,
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
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        // View material
                      },
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              IconlyBroken.show,
                              size: 18,
                              color: Color(0xFF4361EE),
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Просмотр",
                              style: TextStyle(
                                color: Color(0xFF4361EE),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 24,
                  color: Colors.grey[300],
                ),
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        // Share material
                      },
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(16),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              IconlyBroken.send,
                              size: 18,
                              color: Color(0xFF4361EE),
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Поделиться",
                              style: TextStyle(
                                color: Color(0xFF4361EE),
                                fontWeight: FontWeight.w500,
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
        ],
      ),
    );
  }
}
