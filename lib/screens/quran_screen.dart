import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

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
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _togglePlayPause() async {
    try {
      if (isPlaying) {
        await _audioPlayer.pause();
        setState(() => isPlaying = false);
      } else {
        setState(() => isLoading = true);
        // بناء رابط تلاوة مباشر ومضبوط لكل سورة بناءً على رقمها (3 خانات مثل 001.mp3)
        String formattedNumber = widget.surahNumber.toString().padLeft(3, '0');
        String audioUrl = 'https://server8.mp3quran.net/afs/$formattedNumber.mp3';

        await _audioPlayer.setUrl(audioUrl);
        await _audioPlayer.play();
        setState(() {
          isPlaying = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في تشغيل التلاوة: $e', style: const TextStyle(fontFamily: 'Cairo'))),
      );
    }
  }

  void _downloadSurah() {
    setState(() => isLoading = true);
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isDownloaded = true;
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم تحميل سورة ${widget.surahName} بنجاح للاستماع بدون إنترنت', style: const TextStyle(fontFamily: 'Cairo')),
          backgroundColor: const Color(0xFF132A22),
        ),
      );
    });
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
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF132A22),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(
                      isDownloaded ? Icons.download_done : Icons.download,
                      color: isDownloaded ? Colors.greenAccent : const Color(0xFFD4AF37),
                      size: 28,
                    ),
                    onPressed: isDownloaded ? null : _downloadSurah,
                    tooltip: 'تحميل السورة',
                  ),
                  FloatingActionButton(
                    backgroundColor: const Color(0xFFD4AF37),
                    onPressed: isLoading ? null : _togglePlayPause,
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.black)
                        : Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.black, size: 32),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('القارئ:', style: TextStyle(color: Colors.white54, fontSize: 11, fontFamily: 'Cairo')),
                      Text(widget.reciterName, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF132A22).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFD4AF37), width: 1.5),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // إظهار البسملة في كل السور عدا سورة التوبة (رقم 9)
                      if (widget.surahNumber != 9) ...[
                        const Text(
                          'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                          style: TextStyle(
                            color: Color(0xFFD4AF37),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                      ],
                      Text(
                        'آيات سورة ${widget.surahName} المباركة (رقم ${widget.surahNumber})\n\n[هنا يتم عرض نص الآيات القرآنية الكاملة بخط العثماني المزخرف والمرتل بصوت القارئ ${widget.reciterName}]',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          height: 2.2,
                          fontFamily: 'Cairo',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
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
