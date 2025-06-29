import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:trelpix/data/models/review_model.dart';

part 'reviews_response_model.g.dart';

@HiveType(typeId: 6)
class ReviewsResponseModel extends Equatable {
  @HiveField(0)
  final int id; // The movie ID for which reviews are fetched
  @HiveField(1)
  final int page;
  @HiveField(2)
  final List<ReviewModel> results;
  @HiveField(3)
  final int totalPages;
  @HiveField(4)
  final int totalResults;

  const ReviewsResponseModel({
    required this.id,
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory ReviewsResponseModel.fromJson(Map<String, dynamic> json) {
    return ReviewsResponseModel(
      id: json['id'] as int,
      page: json['page'] as int,
      results:
          (json['results'] as List<dynamic>?)
              ?.map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      totalPages: json['total_pages'] as int,
      totalResults: json['total_results'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'page': page,
      'results': results.map((e) => e.toJson()).toList(),
      'total_pages': totalPages,
      'total_results': totalResults,
    };
  }

  @override
  List<Object?> get props => [id, page, results, totalPages, totalResults];
}
