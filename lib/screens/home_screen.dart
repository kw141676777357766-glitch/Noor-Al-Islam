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
  String selectedFilter = 'الكل';
  String searchQuery = '';
  String selectedReciter = 'مشاري العفاسي';

  final List<String> reciters = [
    'مشاري العفاسي',
    'عبد الرحمن السديس',
    'ماهر المعقيلي',
    'محمود خليل الحصري',
    'محمد صديق المنشاوي'
  ];

  // قائمة الـ 114 سورة القرآنية كاملة وموثقة
  final List<Map<String, dynamic>> allSurahs = [
    {'number': 1, 'name': 'الفاتحة', 'details': '7 آيات • مكية', 'type': 'مكية'},
    {'number': 2, 'name': 'البقرة', 'details': '286 آية • مدنية', 'type': 'مدنية'},
    {'number': 3, 'name': 'آل عمران', 'details': '200 آية • مدنية', 'type': 'مدنية'},
    {'number': 4, 'name': 'النساء', 'details': '176 آية • مدنية', 'type': 'مدنية'},
    {'number': 5, 'name': 'المائدة', 'details': '120 آية • مدنية', 'type': 'مدنية'},
    {'number': 6, 'name': 'الأنعام', 'details': '165 آية • مكية', 'type': 'مكية'},
    {'number': 7, 'name': 'الأعراف', 'details': '206 آية • مكية', 'type': 'مكية'},
    {'number': 8, 'name': 'الأنفال', 'details': '75 آية • مدنية', 'type': 'مدنية'},
    {'number': 9, 'name': 'التوبة', 'details': '129 آية • مدنية', 'type': 'مدنية'},
    {'number': 10, 'name': 'يونس', 'details': '109 آية • مكية', 'type': 'مكية'},
    {'number': 11, 'name': 'هود', 'details': '123 آية • مكية', 'type': 'مكية'},
    {'number': 12, 'name': 'يوسف', 'details': '111 آية • مكية', 'type': 'مكية'},
    {'number': 13, 'name': 'الرعد', 'details': '43 آية • مدنية', 'type': 'مدنية'},
    {'number': 14, 'name': 'إبراهيم', 'details': '52 آية • مكية', 'type': 'مكية'},
    {'number': 15, 'name': 'الحجر', 'details': '99 آية • مكية', 'type': 'مكية'},
    {'number': 16, 'name': 'النحل', 'details': '128 آية • مكية', 'type': 'مكية'},
    {'number': 17, 'name': 'الإسراء', 'details': '111 آية • مكية', 'type': 'مكية'},
    {'number': 18, 'name': 'الكهف', 'details': '110 آية • مكية', 'type': 'مكية'},
    {'number': 19, 'name': 'مريم', 'details': '98 آية • مكية', 'type': 'مكية'},
    {'number': 20, 'name': 'طه', 'details': '135 آية • مكية', 'type': 'مكية'},
    {'number': 21, 'name': 'الأنبياء', 'details': '112 آية • مكية', 'type': 'مكية'},
    {'number': 22, 'name': 'الحج', 'details': '78 آية • مدنية', 'type': 'مدنية'},
    {'number': 23, 'name': 'المؤمنون', 'details': '118 آية • مكية', 'type': 'مكية'},
    {'number': 24, 'name': 'النور', 'details': '64 آية • مدنية', 'type': 'مدنية'},
    {'number': 25, 'name': 'الفرقان', 'details': '77 آية • مكية', 'type': 'مكية'},
    {'number': 26, 'name': 'الشعراء', 'details': '227 آية • مكية', 'type': 'مكية'},
    {'number': 27, 'name': 'النمل', 'details': '93 آية • مكية', 'type': 'مكية'},
    {'number': 28, 'name': 'القصص', 'details': '88 آية • مكية', 'type': 'مكية'},
    {'number': 29, 'name': 'العنكبوت', 'details': '69 آية • مكية', 'type': 'مكية'},
    {'number': 30, 'name': 'الروم', 'details': '60 آية • مكية', 'type': 'مكية'},
    {'number': 31, 'name': 'لقمان', 'details': '34 آية • مكية', 'type': 'مكية'},
    {'number': 32, 'name': 'السجدة', 'details': '30 آية • مكية', 'type': 'مكية'},
    {'number': 33, 'name': 'الأحزاب', 'details': '73 آية • مدنية', 'type': 'مدنية'},
    {'number': 34, 'name': 'سبأ', 'details': '54 آية • مكية', 'type': 'مكية'},
    {'number': 35, 'name': 'فاطر', 'details': '45 آية • مكية', 'type': 'مكية'},
    {'number': 36, 'name': 'يس', 'details': '83 آية • مكية', 'type': 'مكية'},
    {'number': 37, 'name': 'الصافات', 'details': '182 آية • مكية', 'type': 'مكية'},
    {'number': 38, 'name': 'ص', 'details': '88 آية • مكية', 'type': 'مكية'},
    {'number': 39, 'name': 'الزمر', 'details': '75 آية • مكية', 'type': 'مكية'},
    {'number': 40, 'name': 'غافر', 'details': '85 آية • مكية', 'type': 'مكية'},
    {'number': 41, 'name': 'فصلت', 'details': '54 آية • مكية', 'type': 'مكية'},
    {'number': 42, 'name': 'الشورى', 'details': '53 آية • مكية', 'type': 'مكية'},
    {'number': 43, 'name': 'الزخرف', 'details': '89 آية • مكية', 'type': 'مكية'},
    {'number': 44, 'name': 'الدخان', 'details': '59 آية • مكية', 'type': 'مكية'},
    {'number': 45, 'name': 'الجاثية', 'details': '37 آية • مكية', 'type': 'مكية'},
    {'number': 46, 'name': 'الأحقاف', 'details': '35 آية • مكية', 'type': 'مكية'},
    {'number': 47, 'name': 'محمد', 'details': '38 آية • مدنية', 'type': 'مدنية'},
    {'number': 48, 'name': 'الفتح', 'details': '29 آية • مدنية', 'type': 'مدنية'},
    {'number': 49, 'name': 'الحجرات', 'details': '18 آية • مدنية', 'type': 'مدنية'},
    {'number': 50, 'name': 'ق', 'details': '45 آية • مكية', 'type': 'مكية'},
    {'number': 51, 'name': 'الذاريات', 'details': '60 آية • مكية', 'type': 'مكية'},
    {'number': 52, 'name': 'الطور', 'details': '49 آية • مكية', 'type': 'مكية'},
    {'number': 53, 'name': 'النجم', 'details': '62 آية • مكية', 'type': 'مكية'},
    {'number': 54, 'name': 'القمر', 'details': '55 آية • مكية', 'type': 'مكية'},
    {'number': 55, 'name': 'الرحمن', 'details': '78 آية • مدنية', 'type': 'مدنية'},
    {'number': 56, 'name': 'الواقعة', 'details': '96 آية • مكية', 'type': 'مكية'},
    {'number': 57, 'name': 'الحديد', 'details': '29 آية • مدنية', 'type': 'مدنية'},
    {'number': 58, 'name': 'المجادلة', 'details': '22 آية • مدنية', 'type': 'مدنية'},
    {'number': 59, 'name': 'الحشر', 'details': '24 آية • مدنية', 'type': 'مدنية'},
    {'number': 60, 'name': 'الممتحنة', 'details': '13 آية • مدنية', 'type': 'مدنية'},
    {'number': 61, 'name': 'الصف', 'details': '14 آية • مدنية', 'type': 'مدنية'},
    {'number': 62, 'name': 'الجمعة', 'details': '11 آية • مدنية', 'type': 'مدنية'},
    {'number': 63, 'name': 'المنافقون', 'details': '11 آية • مدنية', 'type': 'مدنية'},
    {'number': 64, 'name': 'التغابن', 'details': '18 آية • مدنية', 'type': 'مدنية'},
    {'number': 65, 'name': 'الطلاق', 'details': '12 آية • مدنية', 'type': 'مدنية'},
    {'number': 66, 'name': 'التحريم', 'details': '12 آية • مدنية', 'type': 'مدنية'},
    {'number': 67, 'name': 'الملك', 'details': '30 آية • مكية', 'type': 'مكية'},
    {'number': 68, 'name': 'القلم', 'details': '52 آية • مكية', 'type': 'مكية'},
    {'number': 69, 'name': 'الحاقة', 'details': '52 آية • مكية', 'type': 'مكية'},
    {'number': 70, 'name': 'المعارج', 'details': '44 آية • مكية', 'type': 'مكية'},
    {'number': 71, 'name': 'نوح', 'details': '28 آية • مكية', 'type': 'مكية'},
    {'number': 72, 'name': 'الجن', 'details': '28 آية • مكية', 'type': 'مكية'},
    {'number': 73, 'name': 'المزمل', 'details': '20 آية • مكية', 'type': 'مكية'},
    {'number': 74, 'name': 'المدثر', 'details': '56 آية • مكية', 'type': 'مكية'},
    {'number': 75, 'name': 'القيامة', 'details': '40 آية • مكية', 'type': 'مكية'},
    {'number': 76, 'name': 'الإنسان', 'details': '31 آية • مدنية', 'type': 'مدنية'},
    {'number': 77, 'name': 'المرسلات', 'details': '50 آية • مكية', 'type': 'مكية'},
    {'number': 78, 'name': 'النبأ', 'details': '40 آية • مكية', 'type': 'مكية'},
    {'number': 79, 'name': 'النازعات', 'details': '46 آية • مكية', 'type': 'مكية'},
    {'number': 80, 'name': 'عبس', 'details': '42 آية • مكية', 'type': 'مكية'},
    {'number': 81, 'name': 'التكوير', 'details': '29 آية • مكية', 'type': 'مكية'},
    {'number': 82, 'name': 'الانفطار', 'details': '19 آية • مكية', 'type': 'مكية'},
    {'number': 83, 'name': 'المطففين', 'details': '36 آية • مكية', 'type': 'مكية'},
    {'number': 84, 'name': 'الانشقاق', 'details': '25 آية • مكية', 'type': 'مكية'},
    {'number': 85, 'name': 'البروج', 'details': '22 آية • مكية', 'type': 'مكية'},
    {'number': 86, 'name': 'الطارق', 'details': '17 آية • مكية', 'type': 'مكية'},
    {'number': 87, 'name': 'الأعلى', 'details': '19 آية • مكية', 'type': 'مكية'},
    {'number': 88, 'name': 'الغاشية', 'details': '26 آية • مكية', 'type': 'مكية'},
    {'number': 89, 'name': 'الفجر', 'details': '30 آية • مكية', 'type': 'مكية'},
    {'number': 90, 'name': 'البلد', 'details': '20 آية • مكية', 'type': 'مكية'},
    {'number': 91, 'name': 'الشمس', 'details': '15 آية • مكية', 'type': 'مكية'},
    {'number': 92, 'name': 'الليل', 'details': '21 آية • مكية', 'type': 'مكية'},
    {'number': 93, 'name': 'الضحى', 'details': '11 آية • مكية', 'type': 'مكية'},
    {'number': 94, 'name': 'الشرح', 'details': '8 آيات • مكية', 'type': 'مكية'},
    {'number': 95, 'name': 'التين', 'details': '8 آيات • مكية', 'type': 'مكية'},
    {'number': 96, 'name': 'العلق', 'details': '19 آية • مكية', 'type': 'مكية'},
    {'number': 97, 'name': 'القدر', 'details': '5 آيات • مكية', 'type': 'مكية'},
    {'number': 98, 'name': 'البينة', 'details': '8 آيات • مدنية', 'type': 'مدنية'},
    {'number': 99, 'name': 'الزلزلة', 'details': '8 آيات • مدنية', 'type': 'مدنية'},
    {'number': 100, 'name': 'العاديات', 'details': '11 آية • مكية', 'type': 'مكية'},
    {'number': 101, 'name': 'القارعة', 'details': '11 آية • مكية', 'type': 'مكية'},
    {'number': 102, 'name': 'التكاثر', 'details': '8 آيات • مكية', 'type': 'مكية'},
    {'number': 103, 'name': 'العصر', 'details': '3 آيات • مكية', 'type': 'مكية'},
    {'number': 104, 'name': 'الهمزة', 'details': '9 آيات • مكية', 'type': 'مكية'},
    {'number': 105, 'name': 'الفيل', 'details': '5 آيات • مكية', 'type': 'مكية'},
    {'number': 106, 'name': 'قريش', 'details': '4 آيات • مكية', 'type': 'مكية'},
    {'number': 107, 'name': 'الماعون', 'details': '7 آيات • مكية', 'type': 'مكية'},
    {'number': 108, 'name': 'الكوثر', 'details': '3 آيات • مكية', 'type': 'مكية'},
    {'number': 109, 'name': 'الكافرون', 'details': '6 آيات • مكية', 'type': 'مكية'},
    {'number': 110, 'name': 'النصر', 'details': '3 آيات • مدنية', 'type': 'مدنية'},
    {'number': 111, 'name': 'المسد', 'details': '5 آيات • مكية', 'type': 'مكية'},
    {'number': 112, 'name': 'الإخلاص', 'details': '4 آيات • مكية', 'type': 'مكية'},
    {'number': 113, 'name': 'الفلق', 'details': '5 آيات • مكية', 'type': 'مكية'},
    {'number': 114, 'name': 'الناس', 'details': '6 آيات • مكية', 'type': 'مكية'},
  ];

  @override
  Widget build(BuildContext context) {
    // تصفية السور حسب الفلتر (مكية/مدنية) وحسب البحث النصي أو رقم السورة
    final filteredSurahs = allSurahs.where((surah) {
      bool matchesFilter = true;
      if (selectedFilter == 'مكية') matchesFilter = surah['type'] == 'مكية';
      if (selectedFilter == 'مدنية') matchesFilter = surah['type'] == 'مدنية';

      bool matchesSearch = searchQuery.isEmpty ||
          surah['name'].contains(searchQuery) ||
          surah['number'].toString() == searchQuery;

      return matchesFilter && matchesSearch;
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
                  style: TextStyle(color: Color(0xFFD4AF37), fontSize: 16, fontFamily: 'Cairo'),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'نور الإسلام',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Cairo'),
              ),
              const SizedBox(height: 4),
              const Text(
                'القرآن الكريم كاملاً، أذكار، مشاهير القراء، مسحة رقمية، وقصص الأنبياء مع أوقات الصلاة والقبلة.',
                style: TextStyle(fontSize: 13, color: Colors.white60, fontFamily: 'Cairo'),
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
              // بطاقة اختيار القارئ التفاعلية الحقيقية
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF132A22),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'اختر القارئ:',
                      style: TextStyle(color: Color(0xFFD4AF37), fontSize: 14, fontFamily: 'Cairo', fontWeight: FontWeight.bold),
                    ),
                    DropdownButton<String>(
                      value: selectedReciter,
                      dropdownColor: const Color(0xFF132A22),
                      icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFD4AF37)),
                      style: const TextStyle(color: Colors.white, fontFamily: 'Cairo', fontSize: 14),
                      underline: const SizedBox(),
                      items: reciters.map((String reciter) {
                        return DropdownMenuItem<String>(
                          value: reciter,
                          child: Text(reciter, style: const TextStyle(fontFamily: 'Cairo', color: Colors.white)),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedReciter = newValue!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // محرك البحث الفوري المفعل
              TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.trim();
                  });
                },
                style: const TextStyle(color: Colors.white, fontFamily: 'Cairo'),
                decoration: InputDecoration(
                  hintText: 'ابحث باسم السورة أو رقمها (مثال: البقرة أو 2)',
                  hintStyle: const TextStyle(color: Colors.white54, fontSize: 13, fontFamily: 'Cairo'),
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
                style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
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
          style: TextStyle(color: isSelected ? Colors.black : Colors.white70, fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'Cairo'),
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
                MaterialPageRoute(
                  builder: (context) => QuranScreen(
                    surahNumber: number,
                    surahName: name,
                    reciterName: selectedReciter,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
