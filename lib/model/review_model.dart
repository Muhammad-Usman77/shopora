
// 📁 model/review_model.dart
class ReviewModel {
  final String id;
  final String userId;
  final String userName; // ✅ backend .populate("userId", "name") karta hai
  final String productId;
  final int rating;
  final String comment;

  ReviewModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.productId,
    required this.rating,
    required this.comment,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    final userIdValue = map['userId'];
    final userIdStr = userIdValue is Map ? (userIdValue['_id'] ?? "") : (userIdValue ?? "");
    final userNameStr = userIdValue is Map ? (userIdValue['name'] ?? "Anonymous") : "Anonymous";

    return ReviewModel(
      id: map['_id'] ?? map['id'] ?? "",
      userId: userIdStr,
      userName: userNameStr,
      productId: map['productId'] ?? "",
      rating: (map['rating'] as num?)?.toInt() ?? 0,
      comment: map['commentOne'] ?? "",
    );
  }
}



