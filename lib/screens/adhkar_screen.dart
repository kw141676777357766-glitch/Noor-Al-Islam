import 'package:flutter/material.dart';

class AdhkarScreen extends StatelessWidget {
  const AdhkarScreen({super.key});

  final List<Map<String, dynamic>> adhkarCategories = const [
    {
      'title': 'أذكار الصباح',
      'icon': Icons.wb_sunny,
      'items': [
        'أصبحنا وأصبح الملك لله، والحمد لله، لا إله إلا الله وحده لا شريك له...',
        'اللهم بك أصبحنا وبك أمسينا، وبك نحيا وبك نموت وإليك النشور...'
      ]
    },
    {
      'title': 'أذكار المساء',
      'icon': Icons.nightlight_round,
      'items': [
        'أمسينا وأمسى الملك لله، والحمد لله، لا إله إلا الله وحده لا شريك له...',
        'اللهم بك أمسينا وبك أصبحنا، وبك نحيا وبك نموت وإليك المصير...'
      ]
    },
    {
      'title': 'أذكار النوم',
      'icon': Icons.bed,
      'items': [
        'باسمك ربي وضعت جنبي وبك أرفعه، إن أمسكت نفسي فارحمها وإن أرسلتها فاحفظها...',
        'اللهم قني عذابك يوم تبعث عبادك (ثلاث مرات)'
      ]
    },
    {
      'title': 'أذكار بعد الصلاة',
      'icon': Icons.mosque,
      'items': [
        'استغفر الله (ثلاثاً)، اللهم أنت السلام ومنك السلام، تباركت يا ذا الجلال والإكرام...',
        'لا إله إلا الله وحده لا شريك له، له الملك وله الحمد وهو على كل شيء قدير...'
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'الأذكار اليومية',
          style: TextStyle(fontFamily: 'Cairo', color: Color(0xFFD4AF37)),
        ),
        backgroundColor: const Color(0xFF132A22),
        iconTheme: const IconThemeData(color: Color(0xFFD4AF37)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: adhkarCategories.length,
        itemBuilder: (context, index) {
          final category = adhkarCategories[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF132A22),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2)),
            ),
            child: ExpansionTile(
              collapsedIconColor: const Color(0xFFD4AF37),
              iconColor: const Color(0xFFD4AF37),
              leading: Icon(category['icon'], color: const Color(0xFFD4AF37)),
              title: Text(
                category['title'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
              children: (category['items'] as List<String>).map((item) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B1B15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontFamily: 'Cairo',
                      height: 1.5,
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
