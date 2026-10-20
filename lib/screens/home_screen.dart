import 'package:flutter/material.dart';
import 'quran_screen.dart';
import 'adhkar_screen.dart';
import 'misbaha_screen.dart';
import 'prophets_screen.dart';
import 'prayer_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedFilter = 'الكل'; // الفلتر الافتراضي

  // قائمة نموذجية للسور مع نوعها (مكية أو مدنية)
  final List<Map<String, dynamic>> allSurahs = [
    {'number': 1, 'name': 'الفاتحة', 'details': '7 آيات • مكية', 'type': 'مكية'},
    {'number': 2, 'name': 'البقرة', 'details': '286 آية • مدنية', 'type': 'مدنية'},
    {'number': 3, 'name': 'آل عمران', 'details': '200 آية • مدنية', 'type': 'مدنية'},
    {'number': 4, 'name': 'النساء', 'details': '176 آية • مدنية', 'type': 'مدنية'},
    {'number': 5, 'name': 'المائدة', 'details': '120 آية • مدنية', 'type': 'مدنية'},
    {'number': 6, 'name': 'الأنعام', 'details': '165 آية • مكية', 'type': 'مكية'},
    {'number': 7, 'name': 'الأعراف', 'details': '206 آية • مكية', 'type': 'مكية'},
    {'number': 18, 'name': 'الكهف', 'details': '110 آية • مكية', 'type': 'مكية'},
    {'number': 36, 'name': 'يس', 'details': '83 آية • مكية', 'type': 'مكية'},
    {'number': 67, 'name': 'الملك', 'details': '30 آية • مكية', 'type': 'مكية'},
  ];

  @override
  Widget build(BuildContext context) {
    // تصفية السور بناءً على الزر المختار
    final filteredSurahs = allSurahs.where((surah) {
      if (selectedFilter == 'الكل') return true;
      return surah['type'] == selectedFilter;
    }).toList();

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
                      'القارئ الحالي: مشاري العفاسي',
                      style: TextStyle(color: Color(0xFFD4AF37), fontSize: 14, fontFamily: 'Cairo'),
                    ),
                    Icon(Icons.volume_up, color: Color(0xFFD4AF37)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  hintText: 'ابحث باسم السورة أو رقمها',
                  hintStyle: const TextStyle(color: Colors.white54, fontSize: 14, fontFamily: 'Cairo'),
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
                  Text(
                    'السور (${filteredSurahs.length})',
                    style: const TextStyle(color: Colors.white60, fontSize: 13, fontFamily: 'Cairo'),
                  ),
                  Row(
                    children: [
                      _buildFilterChip('الكل'),
                      const SizedBox(width: 8),
                      _buildFilterChip('مدنية'),
                      const SizedBox(width: 8),
                      _buildFilterChip('مكية'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // عرض السور المتوافقة مع الفلتر
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredSurahs.length,
                itemBuilder: (context, index) {
                  final surah = filteredSurahs[index];
                  return _buildSurahItem(
                    surah['number'],
                    surah['name'],
                    surah['details'],
                    context,
                  );
                },
              ),
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

  Widget _buildFilterChip(String label) {
    bool isSelected = selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: Container(
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
            fontFamily: 'Cairo',
          ),
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
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                ),
                Text(
                  details,
                  style: const TextStyle(color: Colors.white60, fontSize: 12, fontFamily: 'Cairo'),
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
