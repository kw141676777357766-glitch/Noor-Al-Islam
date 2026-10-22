import 'package:flutter/material.dart';

import '../data/adhkar_data.dart';
import '../models/adhkar_model.dart';

class AdhkarScreen extends StatefulWidget {
  const AdhkarScreen({super.key});

  @override
  State<AdhkarScreen> createState() => _AdhkarScreenState();
}

class _AdhkarScreenState extends State<AdhkarScreen> {
  late Future<List<AdhkarCategory>> _categoriesFuture;

  static const Color _background = Color(0xFF0F0B1B);
  static const Color _cardColor = Color(0xFF132A22);
  static const Color _gold = Color(0xFFD4AF37);

  @override
  void initState() {
    super.initState();
    _categoriesFuture = AdhkarData.loadCategories();
  }

  IconData _getIcon(String name) {
    switch (name) {
      case 'wb_sunny':
        return Icons.wb_sunny_rounded;
      case 'dark_mode':
        return Icons.dark_mode_rounded;
      case 'bedtime':
        return Icons.bedtime_rounded;
      case 'alarm':
        return Icons.alarm_rounded;
      case 'mosque':
        return Icons.mosque_rounded;
      case 'restaurant':
        return Icons.restaurant_rounded;
      case 'health_and_safety':
        return Icons.health_and_safety_rounded;
      case 'flight':
        return Icons.flight_rounded;
      case 'water_drop':
        return Icons.water_drop_rounded;
      case 'home':
        return Icons.home_rounded;
      default:
        return Icons.menu_book_rounded;
    }
  }

  void _openCategory(AdhkarCategory category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AdhkarCategoryScreen(category: category),
      ),
    );
  }

  Widget _buildCategoryCard(AdhkarCategory category, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _gold.withOpacity(0.22),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => _openCategory(category),
          child: Padding(
            padding: const EdgeInsets.all(17),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: _gold.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    _getIcon(category.icon),
                    color: _gold,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        category.title,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      if (category.description.isNotEmpty) ...[
                        const SizedBox(height: 5),
                        Text(
                          category.description,
                          textAlign: TextAlign.right,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 12,
                            height: 1.5,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                      const SizedBox(height: 7),
                      Text(
                        '${category.items.length} أذكار',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: _gold.withOpacity(0.9),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_left_rounded,
                  color: Colors.white38,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: _cardColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: _gold),
        title: const Text(
          'الأذكار',
          style: TextStyle(
            color: _gold,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
          ),
        ),
      ),
      body: FutureBuilder<List<AdhkarCategory>>(
        future: _categoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: _gold),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: Colors.orangeAccent,
                      size: 48,
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'تعذر تحميل الأذكار',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'تحقق من بيانات الأذكار ثم حاول مرة أخرى.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white60,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () {
                        setState(() {
                          AdhkarData.clearCache();
                          _categoriesFuture = AdhkarData.loadCategories();
                        });
                      },
                      child: const Text(
                        'إعادة المحاولة',
                        style: TextStyle(fontFamily: 'Cairo'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final categories = snapshot.data ?? [];

          if (categories.isEmpty) {
            return const Center(
              child: Text(
                'لا توجد أذكار حاليًا.',
                style: TextStyle(
                  color: Colors.white70,
                  fontFamily: 'Cairo',
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 22,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _cardColor,
                      _cardColor.withOpacity(0.72),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _gold.withOpacity(0.25),
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.auto_awesome_rounded,
                      color: _gold,
                      size: 34,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'اذكر الله واطمئن',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _gold,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'اختر نوع الذكر الذي تريده',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.65),
                        fontSize: 13,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              ...List.generate(
                categories.length,
                (index) => _buildCategoryCard(
                  categories[index],
                  index,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class AdhkarCategoryScreen extends StatefulWidget {
  final AdhkarCategory category;

  const AdhkarCategoryScreen({
    super.key,
    required this.category,
  });

  @override
  State<AdhkarCategoryScreen> createState() =>
      _AdhkarCategoryScreenState();
}

class _AdhkarCategoryScreenState extends State<AdhkarCategoryScreen> {
  final Map<String, int> _progress = {};

  static const Color _background = Color(0xFF0F0B1B);
  static const Color _cardColor = Color(0xFF132A22);
  static const Color _gold = Color(0xFFD4AF37);

  void _increment(AdhkarItem item) {
    final current = _progress[item.id] ?? 0;

    if (current >= item.count) return;

    setState(() {
      _progress[item.id] = current + 1;
    });
  }

  void _reset(AdhkarItem item) {
    setState(() {
      _progress[item.id] = 0;
    });
  }

  Widget _buildItem(AdhkarItem item, int index) {
    final current = _progress[item.id] ?? 0;
    final completed = current >= item.count;
    final progress = item.count > 0
        ? (current / item.count).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: completed
              ? _gold
              : _gold.withOpacity(0.20),
          width: completed ? 1.4 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _gold.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${index + 1} من ${widget.category.items.length}',
                  style: const TextStyle(
                    color: _gold,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
              const Spacer(),
              if (completed)
                const Icon(
                  Icons.check_circle_rounded,
                  color: _gold,
                  size: 23,
                ),
            ],
          ),
          const SizedBox(height: 17),
          SelectableText(
            item.text,
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
              height: 2,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.16),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    completed
                        ? 'اكتمل الذكر'
                        : 'التكرار: $current من ${item.count}',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: completed ? _gold : Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'إعادة العداد',
                  onPressed: current > 0
                      ? () => _reset(item)
                      : null,
                  icon: const Icon(Icons.refresh_rounded),
                  color: _gold,
                ),
                const SizedBox(width: 5),
                FilledButton.icon(
                  onPressed: completed
                      ? null
                      : () => _increment(item),
                  icon: Icon(
                    completed
                        ? Icons.check_rounded
                        : Icons.touch_app_rounded,
                    size: 18,
                  ),
                  label: Text(
                    completed ? 'تم' : 'ذكرته',
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: _gold,
                    foregroundColor: _background,
                    disabledBackgroundColor: Colors.white12,
                    disabledForegroundColor: Colors.white54,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.white10,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(_gold),
            ),
          ),
          if (item.source.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(color: Colors.white12),
            const SizedBox(height: 6),
            const Text(
              'المصدر',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: _gold,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: 5),
            Text(
              item.source,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                height: 1.7,
                fontFamily: 'Cairo',
              ),
            ),
          ],
          if (item.hadithGrade != null &&
              item.hadithGrade!.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            _InfoRow(
              title: 'درجة الحديث',
              value: item.hadithGrade!,
            ),
          ],
          if (item.virtue.isNotEmpty) ...[
            const SizedBox(height: 12),
            _InfoRow(
              title: 'الفضل',
              value: item.virtue,
            ),
          ],
          if (item.note != null &&
              item.note!.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            _InfoRow(
              title: 'ملاحظة',
              value: item.note!,
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: _cardColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: _gold),
        title: Text(
          widget.category.title,
          style: const TextStyle(
            color: _gold,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
        children: [
          if (widget.category.description.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(bottom: 18),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _gold.withOpacity(0.16),
                ),
              ),
              child: Text(
                widget.category.description,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  height: 1.7,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ...List.generate(
            widget.category.items.length,
            (index) => _buildItem(
              widget.category.items[index],
              index,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String title;
  final String value;

  const _InfoRow({
    required this.title,
    required this.value,
  });

  static const Color _gold = Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              color: _gold,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 12,
              height: 1.7,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }
}
