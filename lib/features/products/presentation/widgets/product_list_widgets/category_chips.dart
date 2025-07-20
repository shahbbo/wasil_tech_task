import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../core/constants/app_colors.dart';

class CategoryChips extends StatelessWidget {
  final List<String> categories;
  final String? selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const CategoryChips({
    super.key,
    required this.categories,
    this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isAll = category.toLowerCase() == "all categories";
          final isSelected = (selectedCategory == null && isAll) ||
              (selectedCategory?.toLowerCase() == category.toLowerCase());

          return Padding(
            padding: EdgeInsets.only(
              right: index == categories.length - 1 ? 0 : 12,
            ),
            child: CategoryChip(
              label: category,
              isSelected: isSelected,
              onTap: () => onCategorySelected(category),
            )
                .animate(delay: (index * 10).ms)
                .fadeIn()
                .slideX(begin: 0.3)
                .then()
                .shimmer(
                  delay: (100 + index * 50).ms,
                  duration: 500.ms,
                  color: Colors.white.withOpacity(0.1),
                ),
          );
        },
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.8),
                  ],
                )
              : LinearGradient(
                  colors: [
                    Colors.grey.shade100,
                    Colors.grey.shade50,
                  ],
                ),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected
                ? AppColors.primary.withOpacity(0.3)
                : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            else
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade700,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(width: 3),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(left: 8),
                child: Icon(
                  Icons.check_circle,
                  size: 16,
                  color: Colors.white,
                )
                    .animate(target: isSelected ? 1 : 0)
                    .scale(begin: const Offset(0, 0))
                    .fadeIn(),
              ),
          ],
        ),
      ),
    )
        .animate(target: isSelected ? 1 : 0)
        .scaleXY(end: 1.05)
        .then()
        .shake(hz: 1, curve: Curves.easeOut);
  }
}
