import 'package:flutter/material.dart';

class AdhkarScreen extends StatelessWidget {
  const AdhkarScreen({super.key});

  final List<Map<String, dynamic>> adhkarCategories = const [
    {
      'title': 'أذكار الصباح والمساء',
      'icon': Icons.wb_sunny,
      'items': [
        {
          'text': 'آية الكرسي (اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ...)',
          'count': 1,
          'virtue': 'من قالها حين يصبح أُجير من الجن حتى يمسي.'
        },
        {
          'text': 'سورة الإخلاص، الفلق، والناس ثلاث مرات',
          'count': 3,
          'virtue': 'تكفيك من كل شيء.'
        },
        {
          'text': 'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ...',
          'count': 1,
          'virtue': 'من قالها موقناً بها فمات من يومه دخل الجنة.'
        },
        {
          'text': 'رضيت بالله رَبّاً، وَبِالإِسْلَامِ دِيناً، وَبِمُحَمَّدٍ صلى الله عليه وسلم نَبِيّاً',
          'count': 3,
          'virtue': 'كان حقاً على الله أن يرضيه يوم القيامة.'
        },
        {
          'text': 'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مع اسمِهِ شَيْءٌ فِي الأَرْضِ وَلا فِي السَّمَاءِ وَهُوَ السَّمِيعُ العَلِيمُ',
          'count': 3,
          'virtue': 'لم يضره شيء في ذلك اليوم.'
        }
      ]
    },
    {
      'title': 'أذكار النوم والاستيقاظ',
      'icon': Icons.nightlight_round,
      'items': [
        {
          'text': 'باسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
          'count': 1,
          'virtue': 'دعاء الاستيقاظ: الحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ.'
        },
        {
          'text': 'جمع الكفين والنفث فيهما وقراءة سورة الإخلاص والمعوذتين والمسح بهما على الجسد',
          'count': 3,
          'virtue': 'حفظ من كل سوء طوال الليل.'
        },
        {
          'text': 'سبحان الله (33)، الحمد لله (33)، الله أكبر (34)',
          'count': 1,
          'virtue': 'خير لك من خادم ومن الدنيا وما فيها عند النوم.'
        }
      ]
    },
    {
      'title': 'أذكار الصلاة وبعد التسليم',
      'icon': Icons.mosque,
      'items': [
        {
          'text': 'أستغفر الله (3 مرات)، اللَّهُمَّ أَنْتَ السَّلَامُ وَمِنْكَ السَّلَامُ، تَبَارَكْتَ يَا ذَا الجَلَالِ وَالإِكْرَامِ',
          'count': 1,
          'virtue': 'من السنة بعد الانقضاء من الصلاة المكتوبة.'
        },
        {
          'text': 'لا إله إلا الله وحده لا شريك له، له الملك وله الحمد وهي على كل شيء قدير',
          'count': 1,
          'virtue': 'غفرت خطيئاته وإن كانت مثل زبد البحر.'
        },
        {
          'text': 'قراءة آية الكرسي بعد كل صلاة مكتوبة',
          'count': 1,
          'virtue': 'لم يمنعه من دخول الجنة إلا أن يموت.'
        }
      ]
    },
    {
      'title': 'أذكار المسجد والوضوء',
      'icon': Icons.location_city,
      'items': [
        {
          'text': 'عند دخول المسجد: اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ',
          'count': 1,
          'virtue': 'وعند الخروج: اللَّهُمَّ إِنِّى أَسْأَلُكَ مِنْ فَضْلِكَ.'
        },
        {
          'text': 'بعد الوضوء: أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ',
          'count': 1,
          'virtue': 'فتحت له أبواب الجنة الثمانية يدخل من أيها شاء.'
        }
      ]
    },
    {
      'title': 'الرقية الشرعية الحصينة',
      'icon': Icons.health_and_safety,
      'items': [
        {
          'text': 'أُعِيذُكُمَا بِكَلِمَاتِ اللَّهِ التَّامَّةِ مِنْ كُلِّ شَيْطَانٍ وَهَامَّةٍ، وَمِنْ كُلِّ عَيْنٍ لَامَّةٍ',
          'count': 3,
          'virtue': 'رقية نبوية مباركة للأهل والأبناء.'
        },
        {
          'text': 'بِسْمِ اللَّهِ أَرْقِيكَ، مِنْ كُلِّ شَيْءٍ يُؤْذِيكَ، مِنْ شَرِّ كُلِّ نَفْسٍ أَوْ عَيْنٍ حَاسِدٍ، اللَّهُ يَشْفِيكَ',
          'count': 3,
          'virtue': 'من أذكار الشفاء والتحصين الشامل.'
        }
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'حصن المسلم (الأذكار الشاملة)',
          style: TextStyle(fontFamily: 'Cairo', color: Color(0xFFD4AF37), fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF132A22),
        iconTheme: const IconThemeData(color: Color(0xFFD4AF37)),
        centerTitle: true,
      ),
      body: Container(
        color: const Color(0xFF0F0B1B),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: adhkarCategories.length,
          itemBuilder: (context, index) {
            final category = adhkarCategories[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF132A22),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
              ),
              child: ExpansionTile(
                leading: Icon(category['icon'], color: const Color(0xFFD4AF37)),
                collapsedIconColor: const Color(0xFFD4AF37),
                iconColor: const Color(0xFFD4AF37),
                title: Text(
                  category['title'],
                  style: const TextStyle(
                    color: Color(0xFFD4AF37),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
                children: (category['items'] as List).map((item) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F0B1B),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.15)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['text'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            height: 1.5,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'التكرار: ${item['count']} مرات',
                              style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 12, fontFamily: 'Cairo', fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: Text(
                                item['virtue'],
                                style: const TextStyle(color: Colors.white60, fontSize: 11, fontFamily: 'Cairo'),
                                textAlign: TextAlign.end,
                              ),
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
      ),
    );
  }
}
