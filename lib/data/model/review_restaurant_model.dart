class ReviewResponse {
  final bool error;
  final String message;
  final List<CustomerReview> customerReviews;

  ReviewResponse({
    required this.error,
    required this.message,
    required this.customerReviews,
  });

  factory ReviewResponse.fromJson(Map<String, dynamic> json) {
    return ReviewResponse(
      error: json["error"],
      message: json["message"],
      customerReviews: List<CustomerReview>.from(
        json["customerReviews"].map((x) => CustomerReview.fromJson(x)),
      ),
    );
  }
}

class CustomerReview {
  final String name;
  final String review;
  final String date;

  CustomerReview(
      {required this.name, required this.review, required this.date});

  factory CustomerReview.fromJson(Map<String, dynamic> json) {
    return CustomerReview(
      name: json["name"],
      review: json["review"],
      date: json["date"],
    );
  }
}
