import 'package:flutter/material.dart';
import 'quran_screen.dart';
import 'adhkar_screen.dart';
import 'misbaha_screen.dart';
import 'prophets_screen.dart';
import 'prayer_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'بسم الله الرحمن الرحيم',
                  style: TextStyle(
                    color: Color(0xFFD4AF37),
                    fontSize: 16,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'نور الإسلام',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'القرآن الكريم كاملاً، أذكار، مشاهير القراء، مسحة رقمية، وقصص الأنبياء مع أوقات الصلاة والقبلة.',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white60,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 20),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.2,
                children: [
                  _buildMainCard(Icons.auto_awesome, 'الأذكار', () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AdhkarScreen()));
                  }),
                  _buildMainCard(Icons.track_changes, 'المسبحة', () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const MisbahaScreen()));
                  }),
                  _buildMainCard(Icons.menu_book, 'قصص الأنبياء', () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ProphetsScreen()));
                  }),
                  _buildMainCard(Icons.explore, 'الصلاة والقبلة', () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PrayerScreen()));
                  }),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF132A22),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'القارئ الحالي',
                      style: TextStyle(color: Color(0xFFD4AF37), fontSize: 14),
                    ),
                    Text(
                      'Mishary Alafasy',
                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  hintText: 'ابحث باسم السورة أو رقمها',
                  hintStyle: const TextStyle(color: Colors.white54, fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFFD4AF37)),
                  filled: true,
                  fillColor: const Color(0xFF132A22),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'سورة 114',
                    style: TextStyle(color: Colors.white60, fontSize: 13),
                  ),
                  Row(
                    children: [
                      _buildFilterChip('مدنية', false),
                      const SizedBox(width: 8),
                      _buildFilterChip('مكية', true),
                      const SizedBox(width: 8),
                      _buildFilterChip('الكل', false),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildSurahItem(1, 'الفاتحة', '7 آيات • مكية', context),
              _buildSurahItem(2, 'البقرة', '286 آية • مدنية', context),
              _buildSurahItem(3, 'آل عمران', '200 آية • مدنية', context),
              _buildSurahItem(4, 'النساء', '176 آية • مدنية', context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainCard(IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF132A22),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFD4AF37), size: 24),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFD4AF37) : const Color(0xFF132A22),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.white70,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildSurahItem(int number, String name, String details, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF132A22),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFD4AF37)),
            ),
            child: Text(
              '$number',
              style: const TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  details,
                  style: const TextStyle(color: Colors.white64, fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.play_circle_fill, color: Color(0xFFD4AF37), size: 32),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QuranScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
