import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../core/constants/app_colors.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSearchChanged;

  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.onSearchChanged,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.grey.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: widget.controller,
        onChanged: widget.onSearchChanged,
        onTap: () => setState(() => _isFocused = true),
        onTapOutside: (_) => setState(() => _isFocused = false),
        decoration: InputDecoration(
          hintText: 'Search for products...',
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: _isFocused ? AppColors.primary : Colors.grey.shade500,
            size: 24,
          )
              .animate(target: _isFocused ? 1 : 0)
              .tint(color: AppColors.primary)
              .scale(end: const Offset(1.1, 1.1)),
          suffixIcon: widget.controller.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    widget.controller.clear();
                    widget.onSearchChanged('');
                  },
                  icon: Icon(
                    Icons.clear_rounded,
                    color: Colors.grey.shade500,
                  ),
                ).animate().fadeIn().scale(begin: const Offset(0, 0))
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ).animate(target: _isFocused ? 1 : 0).scaleXY(end: 1.02).then().shimmer(
          delay: 200.ms,
          duration: 1000.ms,
          color: AppColors.primary.withOpacity(0.1),
        );
  }
}
