import 'package:flutter/material.dart';
import 'package:flutter_application_api/API/api_constants.dart';

class CategorySelector extends StatelessWidget {
  final String activeCategory;
  final Function(String endpoint, String name) onCategorySelected;

  const CategorySelector({
    super.key,
    required this.activeCategory,
    required this.onCategorySelected,
  });

  static final List<Map<String, String>> categories = [
    {'name': 'Now Playing', 'endpoint': Constants.nowPlayingEndpoint},
    {'name': 'Popular', 'endpoint': Constants.popularEndpoint},
    {'name': 'Top Rated', 'endpoint': Constants.topRatedEndpoint},
    {'name': 'Upcoming', 'endpoint': Constants.upcomingEndpoint},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final bool isSelected = activeCategory == cat['name'];

          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ChoiceChip(
              label: Text(
                cat['name']!,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 13,
                ),
              ),
              selected: isSelected,
              selectedColor: const Color(0xFFF59E0B),
              backgroundColor: const Color(0xFF1E293B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected
                      ? const Color(0xFFF59E0B)
                      : Colors.white12,
                ),
              ),
              onSelected: (selected) {
                if (selected) {
                  onCategorySelected(cat['endpoint']!, cat['name']!);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
