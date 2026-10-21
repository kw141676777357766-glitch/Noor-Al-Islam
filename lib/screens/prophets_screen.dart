import 'package:flutter/material.dart';

import '../data/prophets_data.dart';
import '../models/prophet_model.dart';
import 'prophet_details_screen.dart';

class ProphetsScreen extends StatefulWidget {
  const ProphetsScreen({super.key});

  @override
  State<ProphetsScreen> createState() => _ProphetsScreenState();
}

class _ProphetsScreenState extends State<ProphetsScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<Prophet> _allProphets = [];
  List<Prophet> _filteredProphets = [];

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProphets();
    _searchController.addListener(_filterProphets);
  }

  /// تحميل بيانات الأنبياء.
  Future<void> _loadProphets() async {
    try {
      final prophets = await ProphetsData.loadProphets();

      if (!mounted) return;

      setState(() {
        _allProphets = prophets;
        _filteredProphets = prophets;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = error.toString();
      });
    }
  }

  /// البحث الفوري في أسماء الأنبياء ووصفهم.
  void _filterProphets() {
    final query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      setState(() {
        _filteredProphets = _allProphets;
      });
      return;
    }

    setState(() {
      _filteredProphets = _allProphets.where((prophet) {
        final name = prophet.name.toLowerCase();
        final title = prophet.title.toLowerCase();
        final description = prophet.shortDescription.toLowerCase();

        return name.contains(query) ||
            title.contains(query) ||
            description.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterProphets);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF071A14),
      appBar: AppBar(
        backgroundColor: const Color(0xFF071A14),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'قصص الأنبياء',
          style: TextStyle(
            color: Color(0xFFD4AF37),
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFFD4AF37),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBox(),
            const SizedBox(height: 12),
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  /// الجزء العلوي التعريفي للشاشة.
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF12382C),
              Color(0xFF0B241B),
            ],
          ),
          border: Border.all(
            color: const Color(0xFFD4AF37).withOpacity(0.22),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.22),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Color(0xFFD4AF37),
              child: Icon(
                Icons.menu_book_rounded,
                color: Color(0xFF071A14),
                size: 29,
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'رحلة مع أنبياء الله',
                    style: TextStyle(
                      color: Color(0xFFD4AF37),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'تعرّف على قصصهم والعبر المستفادة منها',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      height: 1.5,
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

  /// مربع البحث.
  Widget _buildSearchBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: _searchController,
        textDirection: TextDirection.rtl,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          hintText: 'ابحث عن نبي...',
          hintTextDirection: TextDirection.rtl,
          hintStyle: const TextStyle(
            color: Colors.white54,
            fontSize: 14,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: Color(0xFFD4AF37),
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                  },
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Colors.white54,
                  ),
                )
              : null,
          filled: true,
          fillColor: const Color(0xFF102820),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 15,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: const Color(0xFFD4AF37).withOpacity(0.12),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFFD4AF37),
              width: 1.2,
            ),
          ),
        ),
      ),
    );
  }

  /// تحديد محتوى الشاشة حسب حالة التحميل.
  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFFD4AF37),
        ),
      );
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    if (_filteredProphets.isEmpty) {
      return _buildEmptyState();
    }

    return _buildProphetsList();
  }

  /// قائمة الأنبياء.
  Widget _buildProphetsList() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      itemCount: _filteredProphets.length,
      itemBuilder: (context, index) {
        final prophet = _filteredProphets[index];

        return _ProphetCard(
          prophet: prophet,
          index: index,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProphetDetailsScreen(
                  prophet: prophet,
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// حالة عدم وجود نتائج بحث.
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 60,
              color: const Color(0xFFD4AF37).withOpacity(0.55),
            ),
            const SizedBox(height: 15),
            const Text(
              'لم نجد نبيًا بهذا الاسم',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'جرّب كتابة اسم مختلف في مربع البحث.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white54,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// حالة حدوث خطأ أثناء تحميل البيانات.
  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.redAccent,
              size: 58,
            ),
            const SizedBox(height: 15),
            const Text(
              'تعذر تحميل قصص الأنبياء',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'حدث خطأ غير معروف.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _errorMessage = null;
                });

                _loadProphets();
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('إعادة المحاولة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37),
                foregroundColor: const Color(0xFF071A14),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// بطاقة النبي.
class _ProphetCard extends StatelessWidget {
  final Prophet prophet;
  final int index;
  final VoidCallback onTap;

  const _ProphetCard({
    required this.prophet,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          splashColor: const Color(0xFFD4AF37).withOpacity(0.08),
          highlightColor: const Color(0xFFD4AF37).withOpacity(0.04),
          child: Ink(
            decoration: BoxDecoration(
              color: const Color(0xFF102820),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFFD4AF37).withOpacity(0.12),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  _buildNumber(),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildInformation(),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Color(0xFFD4AF37),
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNumber() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFD4AF37).withOpacity(0.10),
        border: Border.all(
          color: const Color(0xFFD4AF37).withOpacity(0.30),
        ),
      ),
      child: Center(
        child: Text(
          '${index + 1}',
          style: const TextStyle(
            color: Color(0xFFD4AF37),
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          prophet.name,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (prophet.title.isNotEmpty) ...[
          const SizedBox(height: 3),
          Text(
            prophet.title,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Color(0xFFD4AF37),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
        const SizedBox(height: 6),
        Text(
          prophet.shortDescription,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 12,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}
