import 'dart:async';
import 'dart:math' as math;

import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrayerScreen extends StatefulWidget {
  const PrayerScreen({super.key});

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  static const Color darkGreen = Color(0xFF132A22);
  static const Color darker = Color(0xFF0F0B1B);
  static const Color gold = Color(0xFFD4AF37);

  bool automaticLocation = true;
  bool loading = true;
  bool locationPermissionDenied = false;

  double? latitude;
  double? longitude;
  double? qiblaDirection;

  String locationName = 'جارٍ تحديد موقعك...';
  String countryName = '';

  PrayerTimes? prayerTimes;

  Timer? _timer;
  DateTime now = DateTime.now();

  final Map<String, String> manualTimes = {
    'الفجر': '04:35',
    'الشروق': '05:52',
    'الظهر': '12:04',
    'العصر': '15:18',
    'المغرب': '18:12',
    'العشاء': '19:25',
  };

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _startClock();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startClock() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          now = DateTime.now();
        });
      }
    });
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    automaticLocation = prefs.getBool('prayer_auto_location') ?? true;

    if (!automaticLocation) {
      latitude = prefs.getDouble('prayer_manual_latitude');
      longitude = prefs.getDouble('prayer_manual_longitude');
      locationName =
          prefs.getString('prayer_manual_city') ?? 'الموقع اليدوي';
      countryName = prefs.getString('prayer_manual_country') ?? '';

      if (latitude != null && longitude != null) {
        _calculatePrayerTimes();
      } else if (mounted) {
        setState(() {
          loading = false;
        });
      }
      return;
    }

    await _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      loading = true;
      locationPermissionDenied = false;
    });

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      setState(() {
        loading = false;
        locationPermissionDenied = true;
        locationName = 'خدمة الموقع غير مفعّلة';
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      setState(() {
        loading = false;
        locationPermissionDenied = true;
        locationName = 'لم يتم السماح بالوصول إلى الموقع';
      });
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      latitude = position.latitude;
      longitude = position.longitude;

      locationName =
          'الموقع الحالي (${latitude!.toStringAsFixed(2)}, '
          '${longitude!.toStringAsFixed(2)})';

      countryName = '';

      _calculatePrayerTimes();
    } catch (e) {
      setState(() {
        loading = false;
        locationName = 'تعذر تحديد الموقع';
      });
    }
  }

  void _calculatePrayerTimes() {
    if (latitude == null || longitude == null) {
      setState(() {
        loading = false;
      });
      return;
    }

    final coordinates = Coordinates(latitude!, longitude!);

    final params = CalculationMethodParameters.muslimWorldLeague()
      ..madhab = Madhab.shafi;

    final calculated = PrayerTimes(
      coordinates: coordinates,
      date: DateTime(now.year, now.month, now.day),
      calculationParameters: params,
      precision: true,
    );

    final qibla = Qibla.qibla(coordinates);

    setState(() {
      prayerTimes = calculated;
      qiblaDirection = qibla.direction;
      loading = false;
    });
  }

  String _formatTime(DateTime? time) {
    if (time == null) return '--:--';

    final localTime = time.toLocal();
    final hour = localTime.hour.toString().padLeft(2, '0');
    final minute = localTime.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  Map<String, String> _getPrayerTimes() {
    if (prayerTimes == null) {
      return manualTimes;
    }

    return {
      'الفجر': _formatTime(prayerTimes!.fajr),
      'الشروق': _formatTime(prayerTimes!.sunrise),
      'الظهر': _formatTime(prayerTimes!.dhuhr),
      'العصر': _formatTime(prayerTimes!.asr),
      'المغرب': _formatTime(prayerTimes!.maghrib),
      'العشاء': _formatTime(prayerTimes!.isha),
    };
  }

  String _getNextPrayer() {
    final times = _getPrayerTimes();

    final prayerOrder = [
      'الفجر',
      'الظهر',
      'العصر',
      'المغرب',
      'العشاء',
    ];

    for (final prayer in prayerOrder) {
      final parts = times[prayer]!.split(':');

      final hour = int.tryParse(parts[0]) ?? 0;
      final minute = int.tryParse(parts[1]) ?? 0;

      final prayerTime = DateTime(
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      if (prayerTime.isAfter(now)) {
        return prayer;
      }
    }

    return 'الفجر';
  }

  Future<void> _saveAutomaticMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('prayer_auto_location', value);

    setState(() {
      automaticLocation = value;
    });

    if (value) {
      await _getCurrentLocation();
    }
  }

  Future<void> _showManualLocationDialog() async {
    final cityController = TextEditingController(
      text: locationName,
    );

    final latController = TextEditingController(
      text: latitude?.toString() ?? '',
    );

    final lonController = TextEditingController(
      text: longitude?.toString() ?? '',
    );

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: darkGreen,
          title: const Text(
            'تحديد الموقع يدويًا',
            style: TextStyle(
              color: gold,
              fontFamily: 'Cairo',
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: cityController,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Cairo',
                  ),
                  decoration: const InputDecoration(
                    labelText: 'اسم المدينة',
                    labelStyle: TextStyle(
                      color: Colors.white70,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
                TextField(
                  controller: latController,
                  keyboardType:
                      const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'خط العرض',
                    labelStyle: TextStyle(
                      color: Colors.white70,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
                TextField(
                  controller: lonController,
                  keyboardType:
                      const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'خط الطول',
                    labelStyle: TextStyle(
                      color: Colors.white70,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'إلغاء',
                style: TextStyle(
                  color: Colors.white70,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: gold,
              ),
              onPressed: () async {
                final lat =
                    double.tryParse(latController.text.trim());
                final lon =
                    double.tryParse(lonController.text.trim());

                if (lat == null ||
                    lon == null ||
                    lat < -90 ||
                    lat > 90 ||
                    lon < -180 ||
                    lon > 180) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'أدخل إحداثيات صحيحة.',
                        style: TextStyle(fontFamily: 'Cairo'),
                      ),
                    ),
                  );
                  return;
                }

                final prefs =
                    await SharedPreferences.getInstance();

                await prefs.setBool(
                  'prayer_auto_location',
                  false,
                );

                await prefs.setDouble(
                  'prayer_manual_latitude',
                  lat,
                );

                await prefs.setDouble(
                  'prayer_manual_longitude',
                  lon,
                );

                final city = cityController.text.trim().isEmpty
                    ? 'الموقع اليدوي'
                    : cityController.text.trim();

                await prefs.setString(
                  'prayer_manual_city',
                  city,
                );

                if (!mounted) return;

                setState(() {
                  automaticLocation = false;
                  latitude = lat;
                  longitude = lon;
                  locationName = city;
                  countryName = '';
                });

                Navigator.pop(context);

                _calculatePrayerTimes();
              },
              child: const Text(
                'حفظ',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );

    cityController.dispose();
    latController.dispose();
    lonController.dispose();
  }

  Widget _buildLocationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: darkGreen,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: gold.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.location_on,
                color: gold,
              ),
              SizedBox(width: 8),
              Text(
                'موقع مواقيت الصلاة',
                style: TextStyle(
                  color: gold,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            locationName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 14),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'تحديد الموقع تلقائيًا',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Cairo',
              ),
            ),
            subtitle: Text(
              automaticLocation
                  ? 'يستخدم GPS لتحديد موقعك'
                  : 'الموقع محدد يدويًا',
              style: const TextStyle(
                color: Colors.white60,
                fontFamily: 'Cairo',
              ),
            ),
            value: automaticLocation,
            activeColor: gold,
            onChanged: _saveAutomaticMode,
          ),
          if (!automaticLocation)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _showManualLocationDialog,
                icon: const Icon(
                  Icons.edit_location_alt,
                  color: gold,
                ),
                label: const Text(
                  'تغيير الموقع يدويًا',
                  style: TextStyle(
                    color: gold,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPrayerCard(
    String name,
    String time,
    bool isNext,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: isNext ? gold.withOpacity(0.12) : darker,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isNext
              ? gold.withOpacity(0.7)
              : gold.withOpacity(0.15),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isNext ? Icons.notifications_active : Icons.access_time,
            color: gold,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                color: isNext ? gold : Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
            ),
          ),
          Text(
            time,
            style: TextStyle(
              color: isNext ? gold : Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQiblaCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: darkGreen,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: gold.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          const Text(
            '🕋 اتجاه القبلة',
            style: TextStyle(
              color: gold,
              fontSize: 19,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            qiblaDirection == null
                ? 'جارٍ حساب اتجاه القبلة...'
                : 'اتجاه القبلة ${qiblaDirection!.toStringAsFixed(1)}°',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 20),
          StreamBuilder<CompassEvent>(
            stream: FlutterCompass.events,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text(
                  'تعذر قراءة مستشعر البوصلة',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontFamily: 'Cairo',
                  ),
                );
              }

              final heading = snapshot.data?.heading;

              if (heading == null || qiblaDirection == null) {
                return const SizedBox(
                  width: 170,
                  height: 170,
                  child: Center(
                    child: Text(
                      'البوصلة غير متوفرة',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                );
              }

              final angle =
                  (qiblaDirection! - heading) *
                      math.pi /
                      180;

              return Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: darker,
                  border: Border.all(
                    color: gold,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: gold.withOpacity(0.18),
                      blurRadius: 20,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Positioned(
                      top: 10,
                      child: Text(
                        'شمال',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 11,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                    Transform.rotate(
                      angle: angle,
                      child: const Icon(
                        Icons.navigation,
                        color: gold,
                        size: 75,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 15),
          const Text(
            'حرّك الهاتف ببطء حتى يستقر السهم باتجاه الكعبة المشرفة.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white60,
              fontSize: 12,
              height: 1.5,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final times = _getPrayerTimes();
    final nextPrayer = _getNextPrayer();

    return Scaffold(
      backgroundColor: darker,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: darkGreen,
        iconTheme: const IconThemeData(
          color: gold,
        ),
        title: const Text(
          'مواقيت الصلاة والقبلة',
          style: TextStyle(
            color: gold,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(
                color: gold,
              ),
            )
          : RefreshIndicator(
              color: gold,
              backgroundColor: darkGreen,
              onRefresh: automaticLocation
                  ? _getCurrentLocation
                  : () async {
                      _calculatePrayerTimes();
                    },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildLocationCard(),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: darkGreen,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: gold.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'الصلاة القادمة',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontFamily: 'Cairo',
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            nextPrayer,
                            style: const TextStyle(
                              color: gold,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${now.hour.toString().padLeft(2, '0')}:'
                            '${now.minute.toString().padLeft(2, '0')}:'
                            '${now.second.toString().padLeft(2, '0')}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'مواقيت اليوم',
                        style: const TextStyle(
                          color: gold,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...times.entries.map(
                      (entry) => _buildPrayerCard(
                        entry.key,
                        entry.value,
                        entry.key == nextPrayer,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildQiblaCard(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
    );
  }
}
