
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopora/user/provider/review_provider.dart'; // apna sahi path

class ReviewSection extends ConsumerStatefulWidget {
  final String productId;

  const ReviewSection({super.key, required this.productId});

  @override
  ConsumerState<ReviewSection> createState() => _ReviewSectionState();
}

class _ReviewSectionState extends ConsumerState<ReviewSection> {
  final commentController = TextEditingController();
  int selectedRating = 5;

  @override
  void initState() {
    super.initState();
    Future.microtask(_fetchReviews);
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  void _fetchReviews() {
    ref.read(productReviewsProvider.notifier).callApi(
          () => ref
              .read(reviewRepositoryProvider)
              .getProductReviews(widget.productId),
        );
  }

  void _handleSubmitReview() {
    final comment = commentController.text.trim();

    if (comment.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please write a comment")),
      );
      return;
    }

    ref.read(createReviewProvider.notifier).callApi(
          () => ref.read(reviewRepositoryProvider).createReview(
                productId: widget.productId,
                rating: selectedRating,
                commentOne: comment,
              ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final reviewsState = ref.watch(productReviewsProvider);
    final reviews = reviewsState.data ?? [];

    ref.listen(createReviewProvider, (previous, next) {
      if (next.data != null && previous?.data == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Review Submitted!")),
        );
        commentController.clear();
        setState(() => selectedRating = 5);
        ref.read(createReviewProvider.notifier).reset();
        _fetchReviews();
      }

      if (next.error != null && previous?.error != next.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!)),
        );
      }
    });

    final createState = ref.watch(createReviewProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Reviews & Ratings",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 14),

        /// ✅ ADD REVIEW FORM
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Write a review",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 8),

              /// ✅ STAR RATING SELECTOR
              Row(
                children: List.generate(5, (index) {
                  final starValue = index + 1;
                  return GestureDetector(
                    onTap: () => setState(() => selectedRating = starValue),
                    child: Icon(
                      starValue <= selectedRating
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.amber,
                      size: 26,
                    ),
                  );
                }),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: commentController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Share your experience...",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      createState.isLoading ? null : _handleSubmitReview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: createState.isLoading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text("Submit Review",
                          style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        /// ✅ EXISTING REVIEWS LIST
        if (reviewsState.isLoading)
          const Center(child: CircularProgressIndicator())
        else if (reviews.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(child: Text("No reviews yet. Be the first!")),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reviews.length,
            separatorBuilder: (_, __) => const Divider(height: 24),
            itemBuilder: (context, index) {
              final review = reviews[index];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.deepPurple.shade100,
                        child: Text(
                          review.userName.isNotEmpty
                              ? review.userName[0].toUpperCase()
                              : "?",
                          style: const TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              review.userName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                            Row(
                              children: List.generate(5, (i) {
                                return Icon(
                                  i < review.rating
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.amber,
                                  size: 14,
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    review.comment,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                ],
              );
            },
          ),
      ],
    );
  }
}