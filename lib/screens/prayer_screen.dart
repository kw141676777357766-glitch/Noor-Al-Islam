import 'package:flutter/material.dart';

class PrayerScreen extends StatefulWidget {
  const PrayerScreen({super.key});

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  int selectedCityIndex = 0; // صنعاء افتراضياً

  final List<Map<String, dynamic>> worldCities = [
    {
      'city': 'صنعاء',
      'country': 'اليمن',
      'qiblaAngle': 0.38,
      'times': {
        'الفجر': '04:35',
        'الشروق': '05:52',
        'الظهر': '12:04',
        'العصر': '03:18',
        'المغرب': '06:12',
        'العشاء': '07:25'
      }
    },
    {
      'city': 'مكة المكرمة',
      'country': 'السعودية',
      'qiblaAngle': 0.0,
      'times': {
        'الفجر': '04:42',
        'الشروق': '06:01',
        'الظهر': '12:15',
        'العصر': '03:30',
        'المغرب': '06:25',
        'العشاء': '07:55'
      }
    },
    {
      'city': 'القاهرة',
      'country': 'مصر',
      'qiblaAngle': 2.35,
      'times': {
        'الفجر': '04:50',
        'الشروق': '06:15',
        'الظهر': '12:50',
        'العصر': '04:12',
        'المغرب': '07:05',
        'العشاء': '08:22'
      }
    },
    {
      'city': 'دبي',
      'country': 'الإمارات',
      'qiblaAngle': 4.71,
      'times': {
        'الفجر': '05:02',
        'الشروق': '06:20',
        'الظهر': '12:22',
        'العصر': '03:45',
        'المغرب': '06:20',
        'العشاء': '07:40'
      }
    },
  ];

  @override
  Widget build(BuildContext context) {
    final currentCityData = worldCities[selectedCityIndex];
    final Map<String, String> times = Map<String, String>.from(currentCityData['times']);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'أوقات الصلاة والقبلة',
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
                            'اختر المدينة',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
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
                              '${worldCities[index]['city']}, ${worldCities[index]['country']}',
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
                ],
              ),
            ),
            const SizedBox(height: 15),
            const Divider(color: Colors.white24),
            const SizedBox(height: 10),
            Text(
              'مواقيت الصلاة في ${currentCityData['city']} (${currentCityData['country']})',
              style: const TextStyle(
                color: Color(0xFFD4AF37),
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: 15),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: times.length,
              itemBuilder: (context, index) {
                String prayerName = times.keys.elementAt(index);
                String prayerTime = times.values.elementAt(index);

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F0B1B),
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
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
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
                    'يوضح اتجاه السهم نحو الكعبة المشرفة بناء على اختيارك لمدينة ${currentCityData['city']}.',
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
                      color: const Color(0xFF0F0B1B),
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
          ],
        ),
      ),
    );
  }
}
