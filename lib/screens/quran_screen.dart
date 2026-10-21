import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import '../data/quran_data.dart';
import '../models/quran_model.dart';

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

  QuranSurah? surah;

  @override
  void initState() {
    super.initState();

    _audioPlayer = AudioPlayer();

    _loadSurah();
    _checkIfDownloaded();

    _audioPlayer.playerStateStream.listen((state) {
      if (!mounted) return;

      setState(() {
        isPlaying = state.playing;

        if (state.processingState == ProcessingState.completed) {
          isPlaying = false;
        }
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // تحميل السورة من ملف القرآن المحلي
  Future<void> _loadSurah() async {
    try {
      final loadedSurah = await QuranData.getSurah(widget.surahNumber);

      if (!mounted) return;

      setState(() {
        surah = loadedSurah;
        isLoadingAyahs = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoadingAyahs = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'حدث خطأ في تحميل آيات السورة: $e',
            style: const TextStyle(fontFamily: 'Cairo'),
          ),
        ),
      );
    }
  }

  // التحقق هل السورة محملة مسبقًا
  Future<void> _checkIfDownloaded() async {
    try {
      final directory = await getApplicationDocumentsDirectory();

      final fileName =
          'surah_${widget.surahNumber}_${widget.reciterName.hashCode}.mp3';

      final file = File('${directory.path}/$fileName');

      if (await file.exists() && mounted) {
        setState(() {
          isDownloaded = true;
        });
      }
    } catch (_) {
      // تجاهل الخطأ
    }
  }

  // تحديد رابط القارئ
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

  // تحميل التلاوة وحفظها على الهاتف
  Future<void> _downloadAndSaveAudio() async {
    if (isLoadingAudio) return;

    setState(() {
      isLoadingAudio = true;
      downloadProgress = 0.0;
    });

    try {
      final serverUrl = _getReciterServerUrl(widget.reciterName);

      final formattedNumber =
          widget.surahNumber.toString().padLeft(3, '0');

      final audioUrl = '$serverUrl$formattedNumber.mp3';

      final directory = await getApplicationDocumentsDirectory();

      final fileName =
          'surah_${widget.surahNumber}_${widget.reciterName.hashCode}.mp3';

      final file = File('${directory.path}/$fileName');

      final client = http.Client();

      try {
        final request = http.Request(
          'GET',
          Uri.parse(audioUrl),
        );

        final response = await client.send(request);

        if (response.statusCode != 200) {
          throw Exception(
            'تعذر تحميل الملف الصوتي (${response.statusCode})',
          );
        }

        final contentLength = response.contentLength ?? 0;

        int downloadedBytes = 0;

        final bytes = <int>[];

        await response.stream.forEach((chunk) {
          bytes.addAll(chunk);
          downloadedBytes += chunk.length;

          if (contentLength > 0 && mounted) {
            setState(() {
              downloadProgress =
                  downloadedBytes / contentLength;
            });
          }
        });

        await file.writeAsBytes(bytes);
      } finally {
        client.close();
      }

      if (!mounted) return;

      setState(() {
        isDownloaded = true;
        isLoadingAudio = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تم تحميل سورة ${widget.surahName} بنجاح للاستماع بدون إنترنت.',
            style: const TextStyle(fontFamily: 'Cairo'),
          ),
          backgroundColor: const Color(0xFF132A22),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoadingAudio = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'فشل تحميل التلاوة: $e',
            style: const TextStyle(fontFamily: 'Cairo'),
          ),
        ),
      );
    }
  }

  // تشغيل أو إيقاف التلاوة
  Future<void> _togglePlayPause() async {
    if (isLoadingAudio) return;

    try {
      if (isPlaying) {
        await _audioPlayer.pause();
        return;
      }

      setState(() {
        isLoadingAudio = true;
      });

      final directory = await getApplicationDocumentsDirectory();

      final fileName =
          'surah_${widget.surahNumber}_${widget.reciterName.hashCode}.mp3';

      final file = File('${directory.path}/$fileName');

      if (await file.exists()) {
        await _audioPlayer.setFilePath(file.path);
      } else {
        final serverUrl =
            _getReciterServerUrl(widget.reciterName);

        final formattedNumber =
            widget.surahNumber.toString().padLeft(3, '0');

        final audioUrl =
            '$serverUrl$formattedNumber.mp3';

        await _audioPlayer.setUrl(audioUrl);
      }

      await _audioPlayer.play();

      if (!mounted) return;

      setState(() {
        isLoadingAudio = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoadingAudio = false;
        isPlaying = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'خطأ في تشغيل التلاوة: $e',
            style: const TextStyle(fontFamily: 'Cairo'),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0B1B),

      appBar: AppBar(
        title: Text(
          'سورة ${widget.surahName}',
          style: const TextStyle(
            fontFamily: 'Cairo',
            color: Color(0xFFD4AF37),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF132A22),
        iconTheme: const IconThemeData(
          color: Color(0xFFD4AF37),
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [
          // ==============================
          // لوحة التحكم بالتلاوة
          // ==============================
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF132A22),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFD4AF37).withOpacity(0.3),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: Icon(
                        isDownloaded
                            ? Icons.download_done
                            : Icons.download,
                        color: isDownloaded
                            ? Colors.greenAccent
                            : const Color(0xFFD4AF37),
                        size: 28,
                      ),
                      onPressed: isDownloaded
                          ? null
                          : _downloadAndSaveAudio,
                      tooltip:
                          'تحميل السورة للاستماع بدون إنترنت',
                    ),

                    FloatingActionButton(
                      backgroundColor:
                          const Color(0xFFD4AF37),
                      onPressed: isLoadingAudio
                          ? null
                          : _togglePlayPause,
                      child: isLoadingAudio
                          ? const CircularProgressIndicator(
                              color: Colors.black,
                            )
                          : Icon(
                              isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Colors.black,
                              size: 32,
                            ),
                    ),

                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'القارئ الحالي:',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 10,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        Text(
                          widget.reciterName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                if (isLoadingAudio &&
                    downloadProgress > 0) ...[
                  const SizedBox(height: 12),

                  LinearProgressIndicator(
                    value: downloadProgress,
                    backgroundColor: Colors.white24,
                    color: const Color(0xFFD4AF37),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    'جاري التحميل... '
                    '${(downloadProgress * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ],
            ),
          ),

          // ==============================
          // القرآن
          // ==============================
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    const Color(0xFF132A22).withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFD4AF37),
                  width: 1.5,
                ),
              ),
              child: _buildQuranContent(),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildQuranContent() {
  if (isLoadingAyahs) {
    return const Center(
      child: CircularProgressIndicator(
        color: Color(0xFFD4AF37),
      ),
    );
  }

  if (surah == null) {
    return const Center(
      child: Text(
        'تعذر العثور على هذه السورة.',
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Cairo',
          fontSize: 16,
        ),
      ),
    );
  }

  if (surah!.ayahs.isEmpty) {
    return const Center(
      child: Text(
        'لا توجد آيات لهذه السورة.',
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Cairo',
          fontSize: 16,
        ),
      ),
    );
  }

  return ListView(
    children: [
      const SizedBox(height: 16),
      Text.rich(
        TextSpan(
          children: surah!.ayahs.map((ayah) {
            return TextSpan(
              text: '${ayah.text} ﴿${ayah.number}﴾ ',
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
        textDirection: TextDirection.rtl,
      ],
  );
  }
      }
