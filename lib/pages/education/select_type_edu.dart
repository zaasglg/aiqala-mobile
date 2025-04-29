import 'package:aiqala/pages/education/teacher/student_main.dart';
import 'package:aiqala/pages/education/teacher/teacher_main.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter_iconly/flutter_iconly.dart';

class SelectTypeEdu extends StatefulWidget {
  const SelectTypeEdu({super.key});

  @override
  State<SelectTypeEdu> createState() => _SelectTypeEduState();
}

class _SelectTypeEduState extends State<SelectTypeEdu> with SingleTickerProviderStateMixin {
  String? selectedRole;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Выберите роль", style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),),
      ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              
              const SizedBox(
                height: 40,
              ),
      
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    _buildRoleCard(
                      title: 'Учитель',
                      icon: Icons.school_rounded,
                      description: 'Создавайте материалы для обучения',
                      gradient: const [Color(0xff003092), Color(0xff003092)],
                    ),
                    const SizedBox(height: 20),
                    _buildRoleCard(
                      title: 'Ученик',
                      icon: Icons.psychology_rounded,
                      description: 'Получайте доступ к обучению',
                      gradient: const [Color(0xff003092), Color(0xff003092)],
                    ),
                  ],
                ),
              ),
      
            
              const Spacer(),
              
              
            
              if (selectedRole != null)
                Center(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 40),
                    child: ElevatedButton(
                      onPressed: () {
                        if (selectedRole == "Учитель") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TeacherMain(),
                            ),
                          );
                        } else if (selectedRole == "Ученик") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StudentMain(),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff003092),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Продолжить',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            IconlyBroken.arrowRight,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required String title,
    required IconData icon,
    required String description,
    required List<Color> gradient,
  }) {
    final isSelected = selectedRole == title;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRole = title;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
        width: double.infinity,
        height: 160,
        decoration: BoxDecoration(
          gradient: isSelected 
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradient,
              )
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, Colors.white],
              ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: isSelected 
                  ? gradient[0].withOpacity(0.4)
                  : Colors.grey.withOpacity(0.1),
              blurRadius: 16,
              offset: const Offset(0, 8),
              spreadRadius: isSelected ? 0 : -4,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background design elements (for selected state)
            if (isSelected)
              Positioned(
                top: -20,
                right: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            if (isSelected)
              Positioned(
                bottom: -30,
                left: -30,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(22.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? Colors.white.withOpacity(0.2)
                          : gradient[0].withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: 40,
                      color: isSelected ? Colors.white : gradient[0],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? Colors.white : const Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: isSelected 
                                ? Colors.white.withOpacity(0.8)
                                : const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}