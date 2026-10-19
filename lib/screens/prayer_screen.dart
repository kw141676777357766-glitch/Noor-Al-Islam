import 'package:flutter/material.dart';

class PrayerScreen extends StatefulWidget {
  const PrayerScreen({super.key});

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  // قائمة المدن العالمية والعربية المتاحة في التطبيق
    final List<Map<String, dynamic>> worldCities = [
    {
      'city': 'صنعاء',
      'country': 'اليمن',
      'qiblaAngle': 0.38, // زاوية القبلة من صنعاء
      'times': {'الفجر': '04:35 ص', 'الشروق': '05:52 ص', 'الظهر': '12:04 م', 'العصر': '03:18 م', 'المغرب': '06:12 م', 'العشاء': '07:25 م'}
    },
    {
      'city': 'مكة المكرمة',
      'country': 'السعودية',
      'qiblaAngle': 0.0, // أنت في مكة بالفعل
      'times': {'الفجر': '04:42 ص', 'الشروق': '06:01 ص', 'الظهر': '12:15 م', 'العصر': '03:30 م', 'المغرب': '06:25 م', 'العشاء': '07:55 م'}
    },
    {
      'city': 'القاهرة',
      'country': 'مصر',
      'qiblaAngle': 2.35, // زاوية القبلة من القاهرة
      'times': {'الفجر': '04:50 ص', 'الشروق': '06:15 ص', 'الظهر': '12:50 م', 'العصر': '04:12 م', 'المغرب': '07:05 م', 'العشاء': '08:22 م'}
    },
    {
      'city': 'دبي',
      'country': 'الإمارات',
      'qiblaAngle': 4.71, // زاوية القبلة من دبي
      'times': {'الفجر': '05:02 ص', 'الشروق': '06:20 ص', 'الظهر': '12:22 م', 'العصر': '03:45 م', 'المغرب': '06:20 م', 'العشاء': '07:40 م'}
    },
    {
      'city': 'إسطنبول',
      'country': 'تركيا',
      'qiblaAngle': 2.75,
      'times': {'الفجر': '05:30 ص', 'الشروق': '07:00 ص', 'الظهر': '01:10 م', 'العصر': '04:30 م', 'المغرب': '07:20 م', 'العشاء': '08:45 م'}
    },
    {
      'city': 'لندن',
      'country': 'بريطانيا',
      'qiblaAngle': 2.15,
      'times': {'الفجر': '05:15 ص', 'الشروق': '06:50 ص', 'الظهر': '01:05 م', 'العصر': '04:15 م', 'المغرب': '07:18 م', 'العشاء': '08:50 م'}
    },
    {
      'city': 'نيويورك',
      'country': 'الولايات المتحدة',
      'qiblaAngle': 1.05,
      'times': {'الفجر': '05:20 ص', 'الشروق': '06:40 ص', 'الظهر': '01:00 م', 'العصر': '04:20 م', 'المغرب': '07:15 م', 'العشاء': '08:30 م'}
    },
  ];


  int selectedCityIndex = 0; // المدينة الافتراضية (صنعاء)

  @override
  Widget build(BuildContext context) {
    final currentCityData = worldCities[selectedCityIndex];
    final Map<String, String> times = currentCityData['times'];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'أوقات الصلاة والقبلة (عالمي)',
          style: TextStyle(fontFamily: 'Cairo', color: Color(0xFFD4AF37)),
        ),
        backgroundColor: const Color(0xFF132A22),
        iconTheme: const IconThemeData(color: Color(0xFFD4AF37)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // زر اختيار المدينة والدولة من جميع أنحاء العالم
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF132A22),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.location_city, color: Color(0xFFD4AF37), size: 22),
                          SizedBox(width: 8),
                          Text(
                            'اختر المدينة:',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                      // القائمة المنسدلة لاختيار أي مدينة في العالم
                      DropdownButton<int>(
                        value: selectedCityIndex,
                        dropdownColor: const Color(0xFF132A22),
                        icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFD4AF37)),
                        style: const TextStyle(color: Colors.white, fontFamily: 'Cairo'),
                        underline: Container(height: 1, color: const Color(0xFFD4AF37)),
                        items: List.generate(worldCities.length, (index) {
                          return DropdownMenuItem<int>(
                            value: index,
                            child: Text(
                              '${worldCities[index]['city']}، ${worldCities[index]['country']}',
                              style: const TextStyle(fontFamily: 'Cairo', color: Colors.white),
                            ),
                          );
                        }),
                        onChanged: (value) {
                          setState(() {
                            selectedCityIndex = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Divider(color: Colors.white24),
                  const SizedBox(height: 10),

                  // عرض اسم المدينة المحددة حالياً
                  Text(
                    'مواقيت الصلاة في: ${currentCityData['city']} (${currentCityData['country']})',
                    style: const TextStyle(
                      color: Color(0xFFD4AF37),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const SizedBox(height: 15),

                  // عرض جدول أوقات الصلاة للمدينة المختارة
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: times.keys.length,
                    itemBuilder: (context, index) {
                      String prayerName = times.keys.elementAt(index);
                      String prayerTime = times.values.elementAt(index);

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0B1B15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.15)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              prayerName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            Text(
                              prayerTime,
                              style: const TextStyle(
                                color: Color(0xFFD4AF37),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            
            // بوصلة القبلة التفاعلية العالمية
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF132A22),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  const Text(
                    'اتجاه القبلة (الكعبة المشرفة)',
                    style: TextStyle(
                      color: Color(0xFFD4AF37),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'يتحدد اتجاه السهم أدناه بدقة نحو الكعبة المشرفة بناءً على اختيارك لمدينة: (${currentCityData['city']}).',
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 13,
                      fontFamily: 'Cairo',
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFD4AF37), width: 3),
                      color: const Color(0xFF0B1B15),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFD4AF37).withOpacity(0.2),
                          blurRadius: 15,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Positioned(
                          top: 10,
                          child: Text('شمال', style: TextStyle(color: Colors.white54, fontSize: 10, fontFamily: 'Cairo')),
                        ),
                        // السهم الذي يدور تلقائياً بحسب زاوية المدينة المختارة
                        Transform.rotate(
                          angle: currentCityData['qiblaAngle'],
                          child: const Icon(
                            Icons.navigation,
                            color: Color(0xFFD4AF37),
                            size: 65,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
