import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _selectedFilter = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(_onFocusChanged);
  }

  void _onFocusChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Center(child: _historyHeader()),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 8,
                  bottom: 100,
                ),
                child: Column(
                  children: [
                    _searchBar(),
                    const SizedBox(height: 20),
                    _filterChips(),
                    const SizedBox(height: 16),
                    _historyList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //  Komponen Header
  Widget _historyHeader() {
    return Column(
      children: const [
        Text(
          'History',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  // komponen search bar
  Widget _searchBar() {
    return GlassTextField(
      controller: _searchController,
      height: 46,
      shape: const LiquidRoundedRectangle(borderRadius: 999),
      placeholder: 'Search history..',
      prefixIcon: const Icon(
        Icons.search_rounded,
        color: Colors.white70,
        size: 20,
      ),
      suffixIcon: _searchController.text.isNotEmpty
          ? IconButton(
              icon: const Icon(
                Icons.close_rounded,
                color: Colors.white70,
                size: 18,
              ),
              onPressed: () {
                setState(() {
                  _searchController.clear();
                });
              },
            )
          : null,
      onChanged: (_) => setState(() {}),
    );
  }

  // Komponen Filter
  Widget _filterChips() {
    final filters = ['All', 'Reels', 'Photos'];
    return Row(
      children: filters.map((filter) {
        final isSelected = _selectedFilter == filter;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilter = filter; // Pilih filter aktif
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 38,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.25)
                      : Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.4)
                        : Colors.white.withValues(alpha: 0.15),
                  ),
                ),
                child: Center(
                  child: Text(
                    filter,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected ? Colors.white : Colors.white54,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _historyList() {
    // Dummy data riwayat media untuk preview UI
    final dummyHistory = [
      {
        'title': 'Instagram Reels Video',
        'type': 'Reels',
        'size': '12.4 MB',
        'date': '2m ago',
        'icon': Icons.movie_rounded,
      },
      {
        'title': 'Instagram Photo Post',
        'type': 'Photos',
        'size': '2.1 MB',
        'date': '1h ago',
        'icon': Icons.photo_library_rounded,
      },
    ];
    // Filter list berdasarkan tombol filter yang dipilih (All / Reels / Photos)
    final filteredList = dummyHistory.where((item) {
      if (_selectedFilter == 'All') return true;
      return item['type'] == _selectedFilter;
    }).toList();
    if (filteredList.isEmpty) {
      return _emptyState();
    }
    return Column(
      children: filteredList.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GlassCard(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // 1. Thumbnail Mini Media
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 54,
                    width: 54,
                    color: Colors.white.withValues(alpha: 0.08),
                    child: Icon(
                      item['icon'] as IconData,
                      color: Colors.white70,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // 2. Info Detail File
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'] as String,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${item['size']} • ${item['date']}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
                // 3. Tombol Aksi Mini (Share & Delete)
                IconButton(
                  icon: const Icon(
                    Icons.share_rounded,
                    color: Colors.white70,
                    size: 18,
                  ),
                  onPressed: () {},
                  tooltip: 'Share',
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.white38,
                    size: 18,
                  ),
                  onPressed: () {},
                  tooltip: 'Delete',
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // Tampilan ketika riwayat kosong
  Widget _emptyState() {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        children: const [
          Icon(
            Icons.history_toggle_off_rounded,
            size: 48,
            color: Colors.white24,
          ),
          SizedBox(height: 12),
          Text(
            'Belum ada riwayat media',
            style: TextStyle(fontSize: 13, color: Colors.white38),
          ),
        ],
      ),
    );
  }
}
