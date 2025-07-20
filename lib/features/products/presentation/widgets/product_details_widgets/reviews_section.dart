import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../domain/entities/product.dart';

class ReviewsSection extends StatefulWidget {
  final List<ProductReview> reviews;
  final double rating;

  const ReviewsSection({
    super.key,
    required this.reviews,
    required this.rating,
  });

  @override
  State<ReviewsSection> createState() => _ReviewsSectionState();
}

class _ReviewsSectionState extends State<ReviewsSection> {
  bool _showAllReviews = false;

  @override
  Widget build(BuildContext context) {
    if (widget.reviews.isEmpty) {
      return _buildNoReviewsCard();
    }

    final displayReviews =
        _showAllReviews ? widget.reviews : widget.reviews.take(3).toList();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.grey.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Rating Summary
          _buildReviewHeader(),

          const SizedBox(height: 20),

          // Rating Distribution
          _buildRatingDistribution(),

          const SizedBox(height: 24),

          // Individual Reviews
          ...displayReviews.asMap().entries.map((entry) {
            final index = entry.key;
            final review = entry.value;
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == displayReviews.length - 1 ? 0 : 16,
              ),
              child: _buildReviewCard(review)
                  .animate(delay: (index * 100).ms)
                  .fadeIn()
                  .slideY(begin: 0.3),
            );
          }),

          // Show More/Less Button
          if (widget.reviews.length > 3) ...[
            const SizedBox(height: 16),
            _buildShowMoreButton(),
          ],
        ],
      ),
    );
  }

  Widget _buildReviewHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.amber.shade400, Colors.orange.shade500],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.reviews,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Customer Reviews',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
              ),
              Row(
                children: [
                  _buildStarRating(widget.rating),
                  const SizedBox(width: 8),
                  Text(
                    '${widget.rating.toStringAsFixed(1)} out of 5',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withOpacity(0.1),
                AppColors.primary.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            '${widget.reviews.length} ${widget.reviews.length == 1 ? 'Review' : 'Reviews'}',
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ).animate().slideX(begin: -0.3).fadeIn();
  }

  Widget _buildRatingDistribution() {
    final ratingCounts = <int, int>{};
    for (int i = 1; i <= 5; i++) {
      ratingCounts[i] = widget.reviews.where((r) => r.rating == i).length;
    }

    return Column(
      children: List.generate(5, (index) {
        final rating = 5 - index;
        final count = ratingCounts[rating] ?? 0;
        final percentage =
            widget.reviews.isNotEmpty ? count / widget.reviews.length : 0.0;

        return Padding(
          padding: EdgeInsets.only(bottom: index == 4 ? 0 : 8),
          child: Row(
            children: [
              Text(
                '$rating',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.star,
                size: 16,
                color: Colors.amber.shade600,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: percentage,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.amber.shade400,
                            Colors.orange.shade500
                          ],
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 30,
                child: Text(
                  '$count',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ).animate(delay: (index * 100).ms).fadeIn().slideX(begin: 0.3);
      }),
    );
  }

  Widget _buildReviewCard(ProductReview review) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey.shade50,
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reviewer Info & Rating
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text(
                  review.reviewerName[0].toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.reviewerName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      DateFormat('MMM dd, yyyy').format(review.date),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStarRating(review.rating.toDouble()),
            ],
          ),

          const SizedBox(height: 12),

          // Review Comment
          Text(
            review.comment,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor()
              ? Icons.star
              : index == rating.floor() && rating % 1 != 0
                  ? Icons.star_half
                  : Icons.star_border,
          color: Colors.amber.shade600,
          size: 16,
        );
      }),
    );
  }

  Widget _buildShowMoreButton() {
    return Center(
      child: TextButton(
        onPressed: () {
          setState(() => _showAllReviews = !_showAllReviews);
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          backgroundColor: AppColors.primary.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _showAllReviews ? 'Show Less' : 'Show All Reviews',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              _showAllReviews ? Icons.expand_less : Icons.expand_more,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.8, 0.8));
  }

  Widget _buildNoReviewsCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey.shade50],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.rate_review_outlined,
              size: 40,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No Reviews Yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Be the first to review this product!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade500,
                ),
          ),
        ],
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9));
  }
}
