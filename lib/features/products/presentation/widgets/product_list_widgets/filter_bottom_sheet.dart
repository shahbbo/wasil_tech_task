import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/app_colors.dart';

class FilterBottomSheet extends StatefulWidget {
  final List<String> categories;
  final String? selectedCategory;
  final String? selectedSort;
  final Function(double, double) onPriceRangeSelected;
  final double minPrice;
  final double maxPrice;
  final double currentMinPrice;
  final double currentMaxPrice;

  const FilterBottomSheet({
    super.key,
    required this.categories,
    this.selectedCategory,
    this.selectedSort,
    required this.onPriceRangeSelected,
    this.minPrice = 0,
    this.maxPrice = 1000,
    this.currentMinPrice = 0,
    this.currentMaxPrice = 1000,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late RangeValues _currentRangeValues;

  @override
  void initState() {
    super.initState();
    // تأكد من أن القيم داخل النطاق المسموح
    _currentRangeValues = RangeValues(
      _clampValue(widget.currentMinPrice, widget.minPrice, widget.maxPrice),
      _clampValue(widget.currentMaxPrice, widget.minPrice, widget.maxPrice),
    );
  }

  @override
  void didUpdateWidget(FilterBottomSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    // تحديث القيم عند تغيير الـ widget properties
    if (oldWidget.minPrice != widget.minPrice ||
        oldWidget.maxPrice != widget.maxPrice ||
        oldWidget.currentMinPrice != widget.currentMinPrice ||
        oldWidget.currentMaxPrice != widget.currentMaxPrice) {
      setState(() {
        _currentRangeValues = RangeValues(
          _clampValue(widget.currentMinPrice, widget.minPrice, widget.maxPrice),
          _clampValue(widget.currentMaxPrice, widget.minPrice, widget.maxPrice),
        );
      });
    }
  }

  // دالة لضمان أن القيمة داخل النطاق المسموح
  double _clampValue(double value, double min, double max) {
    if (max <= min) return min; // تجنب الخطأ إذا كان max <= min
    return value.clamp(min, max);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.maxPrice <= widget.minPrice) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: const Padding(
          padding: EdgeInsets.all(20),
          child: Text('Invalid price range data'),
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle Bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ).animate().fadeIn(delay: 100.ms).scaleX(),

          // Content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary.withOpacity(0.1),
                              AppColors.primary.withOpacity(0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.tune,
                          color: AppColors.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        AppStrings.filterBy,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.2),

                  const SizedBox(height: 24),

                  // Price Range Section Only
                  _buildSectionTitle(
                    context,
                    'Price Range',
                    Icons.attach_money,
                    delay: 300,
                  ),
                  const SizedBox(height: 12),
                  _buildPriceRange()
                      .animate()
                      .fadeIn(delay: 400.ms)
                      .slideY(begin: 0.3),

                  const SizedBox(height: 32),

                  // Apply Button
                  _buildApplyButton()
                      .animate()
                      .fadeIn(delay: 500.ms)
                      .slideY(begin: 0.2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon,
      {int delay = 0}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.primary,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
        ),
      ],
    ).animate().fadeIn(delay: delay.ms).slideX(begin: -0.1);
  }

  Widget _buildPriceRange() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey.shade50,
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Price Display
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPriceBox('\$${_currentRangeValues.start.round()}'),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'to',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _buildPriceBox('\$${_currentRangeValues.end.round()}'),
            ],
          ),
          const SizedBox(height: 20),
          // Range Slider
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 6,
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: Colors.grey.shade300,
              thumbColor: AppColors.primary,
              overlayColor: AppColors.primary.withOpacity(0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
              rangeThumbShape:
                  const RoundRangeSliderThumbShape(enabledThumbRadius: 12),
            ),
            child: RangeSlider(
              values: _currentRangeValues,
              min: widget.minPrice,
              max: widget.maxPrice,
              divisions: _calculateDivisions(),
              labels: RangeLabels(
                '\$${_currentRangeValues.start.round()}',
                '\$${_currentRangeValues.end.round()}',
              ),
              onChanged: (RangeValues values) {
                setState(() {
                  _currentRangeValues = values;
                });
              },
              onChangeEnd: (RangeValues values) {
                widget.onPriceRangeSelected(values.start, values.end);
              },
            ),
          ),
        ],
      ),
    );
  }

  int _calculateDivisions() {
    final range = widget.maxPrice - widget.minPrice;
    if (range <= 0) return 1;

    final divisions = (range / 10).round();
    return divisions > 0 ? divisions : 1;
  }

  Widget _buildPriceBox(String price) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.primary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Text(
        price,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildApplyButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              'Apply Filters',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ).animate().scaleXY(begin: 0.9, end: 0.9).fadeIn();
  }
}
