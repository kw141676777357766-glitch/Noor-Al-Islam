import 'package:flutter/material.dart';

import '../models/prophet_model.dart';

class ProphetDetailsScreen extends StatelessWidget {
  final Prophet prophet;

  const ProphetDetailsScreen({
    super.key,
    required this.prophet,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF071A14),
      appBar: AppBar(
        backgroundColor: const Color(0xFF071A14),
        elevation: 0,
        centerTitle: true,
        title: Text(
          prophet.name,
          style: const TextStyle(
            color: Color(0xFFD4AF37),
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFFD4AF37),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeroSection(),
              const SizedBox(height: 20),
              _buildStorySection(),
              const SizedBox(height: 20),
              _buildEvidenceSection(),
              const SizedBox(height: 20),
              _buildLessonsSection(),
            ],
          ),
        ),
      ),
    );
  }

  /// بطاقة التعريف الرئيسية.
  Widget _buildHeroSection() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFF164333),
            Color(0xFF0B241B),
          ],
        ),
        border: Border.all(
          color: const Color(0xFFD4AF37).withOpacity(0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFD4AF37).withOpacity(0.12),
              border: Border.all(
                color: const Color(0xFFD4AF37).withOpacity(0.5),
                width: 1.5,
              ),
            ),
            child: const Icon(
              Icons.auto_stories_rounded,
              color: Color(0xFFD4AF37),
              size: 38,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            prophet.name,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (prophet.title.isNotEmpty) ...[
            const SizedBox(height: 7),
            Text(
              prophet.title,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFD4AF37),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          const SizedBox(height: 14),
          Text(
            prophet.shortDescription,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }

  /// قسم القصة.
  Widget _buildStorySection() {
    return _buildSectionCard(
      icon: Icons.menu_book_rounded,
      title: 'القصة',
      child: Text(
        prophet.story,
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 15,
          height: 2,
        ),
      ),
    );
  }

  /// قسم الأدلة القرآنية.
  Widget _buildEvidenceSection() {
    if (prophet.evidences.isEmpty) {
      return _buildSectionCard(
        icon: Icons.menu_book_rounded,
        title: 'الأدلة القرآنية',
        child: const Text(
          'لا توجد أدلة مضافة حاليًا.',
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          style: TextStyle(
            color: Colors.white54,
            fontSize: 14,
          ),
        ),
      );
    }

    return _buildSectionCard(
      icon: Icons.menu_book_rounded,
      title: 'الأدلة من القرآن الكريم',
      child: Column(
        children: prophet.evidences.map((evidence) {
          return _buildEvidenceCard(evidence);
        }).toList(),
      ),
    );
  }

  /// بطاقة الدليل القرآني.
  Widget _buildEvidenceCard(QuranEvidence evidence) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF071A14),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD4AF37).withOpacity(0.16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.bookmark_rounded,
                color: Color(0xFFD4AF37),
                size: 19,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'سورة ${evidence.surah} — الآية ${evidence.ayah}',
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Color(0xFFD4AF37),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            evidence.text,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 2,
            ),
          ),
        ],
      ),
    );
  }

  /// قسم الدروس المستفادة.
  Widget _buildLessonsSection() {
    if (prophet.lessons.isEmpty) {
      return const SizedBox.shrink();
    }

    return _buildSectionCard(
      icon: Icons.lightbulb_outline_rounded,
      title: 'الدروس المستفادة',
      child: Column(
        children: prophet.lessons.asMap().entries.map((entry) {
          final index = entry.key;
          final lesson = entry.value;

          return Padding(
            padding: EdgeInsets.only(
              bottom: index == prophet.lessons.length - 1 ? 0 : 12,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 27,
                  height: 27,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFD4AF37).withOpacity(0.12),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Color(0xFFD4AF37),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    lesson,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  /// بطاقة عامة لأقسام صفحة التفاصيل.
  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF102820),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFD4AF37).withOpacity(0.13),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: const Color(0xFFD4AF37),
                size: 22,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  title,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Color(0xFFD4AF37),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
