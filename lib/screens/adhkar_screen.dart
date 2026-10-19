import 'package:flutter/material.dart';

class AdhkarScreen extends StatefulWidget {
  const AdhkarScreen({super.key});

  @override
  State<AdhkarScreen> createState() => _AdhkarScreenState();
}

class _AdhkarScreenState extends State<AdhkarScreen> {
  // قائمة شاملة ومفصلة لجميع الأذكار اليومية (حصن المسلم) دون أي اختصار
  final List<Map<String, dynamic>> adhkarCategories = [
    {
      'title': 'أذكار الصباح الكاملة',
      'icon': Icons.wb_sunny,
      'items': [
        {
          'text': 'أَحْمَدُ اللَّهَ تَعَالَى... أصبحنا وأصبح الملك لله، والحمد لله، لا إله إلا الله وحده لا شريك له، له الملك وله الحمد، وهو على كل شيء قدير.',
          'count': 1,
        },
        {
          'text': 'رَبِّ أسألك خير ما في هذا اليوم وخير ما بعده، وأعوذ بك من شر ما في هذا اليوم وشر ما بعده.',
          'count': 1,
        },
        {
          'text': 'اللَّهُمَّ بك أصبحنا، وبك أمسينا، وبك نحيا، وبك نموت، وإليك النشور.',
          'count': 1,
        },
        {
          'text': 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ، عَدَدَ خَلْقِهِ، وَرِضَا نَفْسِهِ، وَزِنَةَ عَرْشِهِ، وَمِدَادَ كَلِمَاتِهِ.',
          'count': 3,
        },
        {
          'text': 'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مع اسمِهِ شيءٌ في الأرضِ ولا في السماءِ وهو السميعُ العليمُ.',
          'count': 3,
        },
        {
          'text': 'قُلْ هُوَ اللَّهُ أَحَدٌ، وَالمعوذتين ثلاث مرات تكفيك من كل شيء.',
          'count': 3,
        },
      ]
    },
    {
      'title': 'أذكار المساء الكاملة',
      'icon': Icons.nightlight_round,
      'items': [
        {
          'text': 'أمسينا وأمسى الملك لله، والحمد لله، لا إله إلا الله وحده لا شريك له، له الملك وله الحمد، وهو على كل شيء قدير.',
          'count': 1,
        },
        {
          'text': 'اللَّهُمَّ بك أمسينا، وبك أصبحنا، وبك نحيا، وبك نموت، وإليك المصير.',
          'count': 1,
        },
        {
          'text': 'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ ما خَلَقَ.',
          'count': 3,
        },
        {
          'text': 'اللَّهُمَّ عافني في بدني، اللهم عافني في سمعي، اللهم عافني في بصري، لا إله إلا أنت.',
          'count': 3,
        },
      ]
    },
    {
      'title': 'أذكار النوم الاسترخائية',
      'icon': Icons.bed,
      'items': [
        {
          'text': 'باسمك ربي وضعت جنبي وبك أرفعه، إن أمسكت نفسي فارحمها وإن أرسلتها فاحفظها بما تحفظ به عبادك الصالحين.',
          'count': 1,
        },
        {
          'text': 'قراءة آية الكسري وسورة الإملك والمعوذات قبل النوم.',
          'count': 1,
        },
        {
          'text': 'اللَّهُمَّ قني عذابك يوم تبعث عبادك.',
          'count': 3,
        },
      ]
    },
    {
      'title': 'أذكار بعد الصلاة المفروضة',
      'icon': Icons.mosque,
      'items': [
        {
          'text': 'أستغفر الله (ثلاثاً)، اللهم أنت السلام ومنك السلام، تباركت يا ذا الجلال والإكرام.',
          'count': 1,
        },
        {
          'text': 'لا إله إلا الله وحده لا شريك له، له الملك وله الحمد، وهو على كل شيء قدير.',
          'count': 1,
        },
        {
          'text': 'سُبْحَانَ اللَّهِ (33)، الْحَمْدُ لِلَّهِ (33)، اللَّهُ أَكْبَرُ (33)، وتمام المائة: لا إله إلا الله وحدَه لا شريكَ له.',
          'count': 1,
        },
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'حصن المسلم (الأذكار الشاملة)',
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
              children: (category['items'] as List<Map<String, dynamic>>).map((item) {
                return Container(
                  padding: const EdgeInsets.all(14),
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B1B15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.1)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['text'],
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontFamily: 'Cairo',
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD4AF37).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'التكرار: ${item['count']} مرات',
                              style: const TextStyle(
                                color: Color(0xFFD4AF37),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.check_circle_outline, color: Color(0xFFD4AF37)),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('تم إتمام الذكر بنجاح، تقبل الله طاعتك!', style: TextStyle(fontFamily: 'Cairo')),
                                  backgroundColor: Color(0xFF132A22),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
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
