import 'package:flutter/material.dart';

class MisbahaScreen extends StatefulWidget {
  const MisbahaScreen({super.key});

  @override
  State<MisbahaScreen> createState() => _MisbahaScreenState();
}

class _MisbahaScreenState extends State<MisbahaScreen> {
  int counter = 0;
  int currentDhikrIndex = 0;

  // قائمة واسعة ومتنوعة لجميع أذكار التسبيح والاستغفار
  final List<Map<String, dynamic>> adhkarList = [
    {'text': 'سُبْحَانَ اللَّهِ', 'target': 33},
    {'text': 'الْحَمْدُ لِلَّهِ', 'target': 33},
    {'text': 'اللَّهُ أَكْبَرُ', 'target': 33},
    {'text': 'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ', 'target': 100},
    {'text': 'أَسْتَغْفِرُ اللَّهَ الْعَظِيمَ وَأَتُوبُ إِلَيْهِ', 'target': 100},
    {'text': 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ، سُبْحَانَ اللَّهِ الْعَظِيمِ', 'target': 100},
    {'text': 'اللَّهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ', 'target': 100},
    {'text': 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ', 'target': 100},
  ];

  void incrementCounter() {
    setState(() {
      counter++;
    });
  }

  void resetCounter() {
    setState(() {
      counter = 0;
    });
  }

  void nextDhikr() {
    setState(() {
      currentDhikrIndex = (currentDhikrIndex + 1) % adhkarList.length;
      counter = 0; // إعادة التصفير عند الانتقال لذكر جديد
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentDhikr = adhkarList[currentDhikrIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'المسبحة الإلكترونية المطورة',
          style: TextStyle(fontFamily: 'Cairo', color: Color(0xFFD4AF37)),
        ),
        backgroundColor: const Color(0xFF132A22),
        iconTheme: const IconThemeData(color: Color(0xFFD4AF37)),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // عرض الذكر الحالي المستهدف
            const Text(
              'الذكر الحالي:',
              style: TextStyle(color: Colors.white60, fontSize: 14, fontFamily: 'Cairo'),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF132A22),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
              ),
              child: Text(
                currentDhikr['text'],
                style: const TextStyle(
                  color: Color(0xFFD4AF37),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),

            // العداد الدائري التفاعلي الضخم
            GestureDetector(
              onTap: incrementCounter,
              child: Container(
                width: 210,
                height: 210,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF132A22),
                  border: Border.all(color: const Color(0xFFD4AF37), width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD4AF37).withOpacity(0.25),
                      blurRadius: 25,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$counter',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 55,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    Text(
                      'الهدف: ${currentDhikr['target']}',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            // أزرار التحكم (التالي وتصفير العداد)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: nextDhikr,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF132A22),
                    foregroundColor: const Color(0xFFD4AF37),
                    side: const BorderSide(color: Color(0xFFD4AF37)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  icon: const Icon(Icons.swap_horiz),
                  label: const Text('ذكر آخر', style: TextStyle(fontFamily: 'Cairo')),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: resetCounter,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.withOpacity(0.2),
                    foregroundColor: Colors.redAccent,
                    side: const BorderSide(color: Colors.redAccent),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  icon: const Icon(Icons.refresh),
                  label: const Text('تصفير', style: TextStyle(fontFamily: 'Cairo')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
