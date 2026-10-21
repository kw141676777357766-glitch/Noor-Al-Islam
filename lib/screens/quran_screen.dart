import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class QuranScreen extends StatefulWidget {
  final int surahNumber;
  final String surahName;
  final String reciterName;

  const QuranScreen({
    super.key,
    required this.surahNumber,
    required this.surahName,
    required this.reciterName,
  });

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  bool isDownloaded = false;
  bool isLoadingAudio = false;
  bool isLoadingAyahs = true;
  double downloadProgress = 0.0;
  List<dynamic> ayahsList = [];

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _fetchSurahAyahs();
    _checkIfDownloaded();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // التحقق هل السورة محملة مسبقاً في ذاكرة الهاتف للاستماع بدون إنترنت
  Future<void> _checkIfDownloaded() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      String fileName = 'surah_${widget.surahNumber}_${widget.reciterName.hashCode}.mp3';
      File file = File('${directory.path}/$fileName');
      if (await file.exists()) {
        setState(() {
          isDownloaded = true;
        });
      }
    } catch (e) {
      // خطأ صامت
    }
  }

  // جلب الآيات الحقيقية للسورة من API القرآن الكريم المعتمد بالترتيب
  Future<void> _fetchSurahAyahs() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.alquran.cloud/v1/surah/${widget.surahNumber}'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          ayahsList = data['data']['ayahs'];
          isLoadingAyahs = false;
        });
      } else {
        setState(() => isLoadingAyahs = false);
      }
    } catch (e) {
      setState(() => isLoadingAyahs = false);
    }
  }

  // تحديد رابط السيرفر الخاص بكل قارئ بدقة
  String _getReciterServerUrl(String reciter) {
    switch (reciter) {
      case 'عبد الرحمن السديس':
        return 'https://server11.mp3quran.net/sds/';
      case 'ماهر المعقيلي':
        return 'https://server12.mp3quran.net/maher/';
      case 'محمود خليل الحصري':
        return 'https://server13.mp3quran.net/husr/';
      case 'محمد صديق المنشاوي':
        return 'https://server10.mp3quran.net/minsh/';
      case 'مشاري العفاسي':
      default:
        return 'https://server8.mp3quran.net/afs/';
    }
  }

  // تحميل وحفظ ملف الصوت محلياً في الجهاز للعمل بدون إنترنت
  Future<void> _downloadAndSaveAudio() async {
    setState(() {
      isLoadingAudio = true;
      downloadProgress = 0.0;
    });

    try {
      String serverUrl = _getReciterServerUrl(widget.reciterName);
      String formattedNumber = widget.surahNumber.toString().padLeft(3, '0');
      String audioUrl = '$serverUrl$formattedNumber.mp3';

      final directory = await getApplicationDocumentsDirectory();
      String fileName = 'surah_${widget.surahNumber}_${widget.reciterName.hashCode}.mp3';
      File file = File('${directory.path}/$fileName');

      var client = http.Client();
      var request = http.Request('GET', Uri.parse(audioUrl));
      var response = await client.send(request);

      int contentLength = response.contentLength ?? 0;
      int downloadedBytes = 0;

      List<int> bytes = [];
      await response.stream.forEach((chunk) {
        bytes.addAll(chunk);
        downloadedBytes += chunk.length;
        if (contentLength > 0) {
          setState(() {
            downloadProgress = downloadedBytes / contentLength;
          });
        }
      });

      await file.writeAsBytes(bytes);

      setState(() {
        isDownloaded = true;
        isLoadingAudio = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم تحميل وحفظ سورة ${widget.surahName} بصوت ${widget.reciterName} بنجاح للعمل بدون إنترنت!', style: const TextStyle(fontFamily: 'Cairo')),
          backgroundColor: const Color(0xFF132A22),
        ),
      );
    } catch (e) {
      setState(() => isLoadingAudio = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل التحميل، تأكد من اتصال الإنترنت: $e', style: const TextStyle(fontFamily: 'Cairo'))),
      );
    }
  }

  Future<void> _togglePlayPause() async {
    try {
      if (isPlaying) {
        await _audioPlayer.pause();
        setState(() => isPlaying = false);
      } else {
        setState(() => isLoadingAudio = true);

        final directory = await getApplicationDocumentsDirectory();
        String fileName = 'surah_${widget.surahNumber}_${widget.reciterName.hashCode}.mp3';
        File file = File('${directory.path}/$fileName');

        if (await file.exists()) {
          // تشغيل من ملف الهاتف المحلي (بدون إنترنت نهائياً)
          await _audioPlayer.setFilePath(file.path);
        } else {
          // تشغيل عبر الإنترنت مباشرة إذا لم يتم التحميل بعد
          String serverUrl = _getReciterServerUrl(widget.reciterName);
          String formattedNumber = widget.surahNumber.toString().padLeft(3, '0');
          String audioUrl = '$serverUrl$formattedNumber.mp3';
          await _audioPlayer.setUrl(audioUrl);
        }

        await _audioPlayer.play();
        setState(() {
          isPlaying = true;
          isLoadingAudio = false;
        });
      }
    } catch (e) {
      setState(() => isLoadingAudio = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في تشغيل التلاوة: $e', style: const TextStyle(fontFamily: 'Cairo'))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'سورة ${widget.surahName}',
          style: const TextStyle(fontFamily: 'Cairo', color: Color(0xFFD4AF37), fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF132A22),
        iconTheme: const IconThemeData(color: Color(0xFFD4AF37)),
        centerTitle: true,
      ),
      body: Container(
        color: const Color(0xFF0F0B1B),
        child: Column(
          children: [
            // شريط التحكم بالصوت والتحميل والقارئ
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF132A22),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: Icon(
                          isDownloaded ? Icons.download_done : Icons.download,
                          color: isDownloaded ? Colors.greenAccent : const Color(0xFFD4AF37),
                          size: 28,
                        ),
                        onPressed: isDownloaded ? null : _downloadAndSaveAudio,
                        tooltip: 'تحميل السورة للاستماع بدون إنترنت',
                      ),
                      FloatingActionButton(
                        backgroundColor: const Color(0xFFD4AF37),
                        onPressed: isLoadingAudio ? null : _togglePlayPause,
                        child: isLoadingAudio
                            ? const CircularProgressIndicator(color: Colors.black)
                            : Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.black, size: 32),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('القارئ الحالي:', style: TextStyle(color: Colors.white54, fontSize: 10, fontFamily: 'Cairo')),
                          Text(widget.reciterName, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                        ],
                      ),
                    ],
                  ),
                  if (isLoadingAudio && downloadProgress > 0) ...[
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: downloadProgress,
                      backgroundColor: Colors.white24,
                      color: const Color(0xFFD4AF37),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'جاري التحميل... ${(downloadProgress * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(color: Colors.white70, fontSize: 11, fontFamily: 'Cairo'),
                    ),
                  ],
                ],
              ),
            ),
            // عرض الآيات القرآنية الكاملة مرتبة
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF132A22).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFD4AF37), width: 1.5),
                ),
                child: isLoadingAyahs
                    ? const Center(child: CircularProgressIndicator(color: Color(0xFFD4AF37)))
                    : ListView(
                        children: [
                          if (widget.surahNumber != 9 && widget.surahNumber != 1)
                            const Center(
                              child: Text(
                                'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                                style: TextStyle(
                                  color: Color(0xFFD4AF37),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ),
                          const SizedBox(height: 12),
                          Text.rich(
                            TextSpan(
                              children: ayahsList.map((ayah) {
                                int numberInSurah = ayah['numberInSurah'];
                                String text = ayah['text'];
                                if (widget.surahNumber == 1 && numberInSurah == 1) {
                                  text = text.replaceFirst('بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ', '').trim();
                                }
                                return TextSpan(
                                  text: '$text ﴿$numberInSurah﴾ ',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    height: 2.2,
                                    fontFamily: 'Cairo',
                                  ),
                                );
                              }).toList(),
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
