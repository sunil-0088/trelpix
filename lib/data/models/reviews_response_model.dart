import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';
import 'package:trelpix/data/models/review_model.dart';

part 'reviews_response_model.g.dart';

@HiveType(typeId: 6)
@JsonSerializable(fieldRename: FieldRename.snake)
class ReviewsResponseModel extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final int page;
  @HiveField(2)
  final List<ReviewModel> results;
  @HiveField(3)
  final int totalPages;
  @HiveField(4)
  final int totalResults;

  ReviewsResponseModel({
    required this.id,
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory ReviewsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewsResponseModelToJson(this);
}
