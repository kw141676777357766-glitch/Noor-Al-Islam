import 'package:flutter/material.dart';

class QuranScreen extends StatelessWidget {
  const QuranScreen({super.key});

  // قائمة مبسطة تمثيلية لبعض السور (يمكنك توسيعها لتشمل الـ 114 سورة)
  final List<Map<String, dynamic>> surahs = const [
    {'number': 1, 'name': 'الفاتحة', 'ayahs': 7, 'type': 'مكية'},
    {'number': 2, 'name': 'البقرة', 'ayahs': 286, 'type': 'مدنية'},
    {'number': 3, 'name': 'آل عمران', 'ayahs': 200, 'type': 'مدنية'},
    {'number': 4, 'name': 'النساء', 'ayahs': 176, 'type': 'مدنية'},
    {'number': 5, 'name': 'المائدة', 'ayahs': 120, 'type': 'مدنية'},
    {'number': 6, 'name': 'الأنعام', 'ayahs': 165, 'type': 'مكية'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'القرآن الكريم',
          style: TextStyle(fontFamily: 'Cairo', color: Color(0xFFD4AF37)),
        ),
        backgroundColor: const Color(0xFF132A22),
        iconTheme: const IconThemeData(color: Color(0xFFD4AF37)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: surahs.length,
        itemBuilder: (context, index) {
          final surah = surahs[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF132A22),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2)),
            ),
            child: Row(
              children: [
                // رقم السورة
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFD4AF37)),
                  ),
                  child: Text(
                    '${surah['number']}',
                    style: const TextStyle(
                      color: Color(0xFFD4AF37),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                // اسم السورة وتفاصيلها
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        surah['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      Text(
                        '${surah['ayahs']} آية • ${surah['type']}',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ),
                // زر الاستماع أو الدخول للسورة
                IconButton(
                  icon: const Icon(Icons.play_circle_fill, color: Color(0xFFD4AF37), size: 32),
                  onPressed: () {
                    // هنا سيتم فتح تفاصيل السورة والآيات
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
