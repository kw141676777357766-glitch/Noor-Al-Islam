import 'package:flutter/material.dart';

class MisbahaScreen extends StatefulWidget {
  const MisbahaScreen({super.key});

  @override
  State<MisbahaScreen> createState() => _MisbahaScreenState();
}

class _MisbahaScreenState extends State<MisbahaScreen> {
  int counter = 0;
  int currentDhikrIndex = 0;

  final List<String> adhkarList = [
    'سُبْحَانَ اللَّهِ',
    'الْحَمْدُ لِلَّهِ',
    'اللَّهُ أَكْبَرُ',
    'لَا إِلَهَ إِلَّا اللَّهُ',
    'أَسْتَغْفِرُ اللَّهَ وَأَتُوبُ إِلَيْهِ',
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

  void changeDhikr() {
    setState(() {
      currentDhikrIndex = (currentDhikrIndex + 1) % adhkarList.length;
      counter = 0; // إعادة التصفير عند تغيير الذكر
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'المسبحة الإلكترونية',
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
        // عرض التسبيح الحالي
        const Text(
          'ما يقوله المستخدم الآن:',
          style: TextStyle(color: Colors.white60, fontSize: 14, fontFamily: 'Cairo'),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF132A22),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
          ),
          child: Text(
            adhkarList[currentDhikrIndex],
            style: const TextStyle(
              color: Color(0xFFD4AF37),
              fontSize: 26,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 50),

        // العداد الرقمي الكبير (زر التسبيح الرئيسي)
        GestureDetector(
          onTap: incrementCounter,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF132A22),
              border: Border.all(color: const Color(0xFFD4AF37), width: 4),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD4AF37).withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: Text(
                '$counter',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 55,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 40),

        // أزرار التحكم (تغيير الذكر وإعادة الصفر)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: changeDhikr,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF132A22),
                foregroundColor: const Color(0xFFD4AF37),
                side: const BorderSide(color: Color(0xFFD4AF37)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              icon: const Icon(Icons.swap_horiz),
              label: const Text('تغيير الذكر', style: TextStyle(fontFamily: 'Cairo')),
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
