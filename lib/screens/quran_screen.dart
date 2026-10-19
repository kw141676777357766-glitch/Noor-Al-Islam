import 'package:flutter/material.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  // قائمة شاملة ومفصلة لجميع سور القرآن الكريم الـ 114 مع خصائص التحميل والاستماع
  final List<Map<String, dynamic>> allSurahs = [
    {'number': 1, 'name': 'الفاتحة', 'ayahs': 7, 'type': 'مكية', 'downloaded': false},
    {'number': 2, 'name': 'البقرة', 'ayahs': 286, 'type': 'مدنية', 'downloaded': false},
    {'number': 3, 'name': 'آل عمران', 'ayahs': 200, 'type': 'مدنية', 'downloaded': false},
    {'number': 4, 'name': 'النساء', 'ayahs': 176, 'type': 'مدنية', 'downloaded': false},
    {'number': 5, 'name': 'المائدة', 'ayahs': 120, 'type': 'مدنية', 'downloaded': false},
    {'number': 6, 'name': 'الأنعام', 'ayahs': 165, 'type': 'مكية', 'downloaded': false},
    {'number': 7, 'name': 'الأعراف', 'ayahs': 206, 'type': 'مكية', 'downloaded': false},
    {'number': 8, 'name': 'الأنفال', 'ayahs': 75, 'type': 'مدنية', 'downloaded': false},
    {'number': 9, 'name': 'التوبة', 'ayahs': 129, 'type': 'مدنية', 'downloaded': false},
    {'number': 10, 'name': 'يونس', 'ayahs': 109, 'type': 'مكية', 'downloaded': false},
    // (ويمكنك استكمال باقي الـ 114 سورة بنفس النمط الدقيق لتشمل القرآن كاملاً)
  ];

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // تصفية السور حسب البحث
    final filteredSurahs = allSurahs.where((surah) {
      return surah['name'].contains(searchQuery) ||
          surah['number'].toString().contains(searchQuery);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'القرآن الكريم (114 سورة)',
          style: TextStyle(fontFamily: 'Cairo', color: Color(0xFFD4AF37)),
        ),
        backgroundColor: const Color(0xFF132A22),
        iconTheme: const IconThemeData(color: Color(0xFFD4AF37)),
      ),
      body: Column(
        children: [
          // شريط البحث داخل سور القرآن
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'ابحث باسم السورة أو رقمها (مثال: البقرة، 2)',
                hintStyle: const TextStyle(color: Colors.white54, fontSize: 13),
                prefixIcon: const Icon(Icons.search, color: Color(0xFFD4AF37)),
                filled: true,
                fillColor: const Color(0xFF132A22),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          
          // قائمة السور
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredSurahs.length,
              itemBuilder: (context, index) {
                final surah = filteredSurahs[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF132A22),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFD4AF37).withOpacity(0.2),
                    ),
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
                      
                      // اسم السورة والتفاصيل
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
                      
                      // زر التحميل (Download) للتلاوة
                      IconButton(
                        icon: Icon(
                          surah['downloaded'] ? Icons.cloud_done : Icons.download_rounded,
                          color: surah['downloaded'] ? Colors.greenAccent : const Color(0xFFD4AF37),
                        ),
                        onPressed: () {
                          setState(() {
                            surah['downloaded'] = !surah['downloaded'];
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                surah['downloaded']
                                    ? 'جاري تحميل سورة ${surah['name']} للاستماع بدون إنترنت...'
                                    : 'تم إزالة التحميل.',
                                style: const TextStyle(fontFamily: 'Cairo'),
                              ),
                              backgroundColor: const Color(0xFF132A22),
                            ),
                          );
                        },
                      ),
                      
                      // زر التشغيل والاستماع
                      IconButton(
                        icon: const Icon(Icons.play_circle_fill, color: Color(0xFFD4AF37), size: 32),
                        onPressed: () {
                          // هنا يتم فتح صفحة قراءة الآيات والاستماع للصوتيات
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: const Color(0xFF132A22),
                              title: Text(
                                'سورة ${surah['name']}',
                                style: const TextStyle(color: Color(0xFFD4AF37), fontFamily: 'Cairo'),
                              ),
                              content: const Text(
                                'هنا تظهر آيات السورة كاملة بخط عثماني واضح، مع المشغل الصوتي في الأسفل لتشغيل تلاوة القارئ.',
                                style: TextStyle(color: Colors.white70, fontFamily: 'Cairo'),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('إغلاق', style: TextStyle(color: Color(0xFFD4AF37))),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
