import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';
import 'package:trelpix/data/models/author_details_model.dart';
import 'package:trelpix/domain/entities/review.dart';

part 'review_model.g.dart';

@HiveType(typeId: 5) // Unique typeId for ReviewModel
@JsonSerializable(fieldRename: FieldRename.snake)
class ReviewModel extends Review {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String author;

  @HiveField(2)
  final String content;

  @HiveField(3)
  final String? url;

  @HiveField(4)
  @JsonKey(name: 'author_details')
  final AuthorDetailsModel? authorDetails;

  @HiveField(5)
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  const ReviewModel({
    required this.id,
    required this.author,
    required this.content,
    this.url,
    this.authorDetails,
    this.updatedAt,
  }) : super(
         id: id,
         author: author,
         content: content,
         url: url,
         authorDetails: authorDetails,
         updatedAt: updatedAt,
       );

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewModelToJson(this);

  factory ReviewModel.fromEntity(Review review) {
    return ReviewModel(
      id: review.id,
      author: review.author,
      content: review.content,
      url: review.url,
      authorDetails:
          review.authorDetails != null
              ? AuthorDetailsModel.fromEntity(review.authorDetails!)
              : null,
      updatedAt: review.updatedAt,
    );
  }
}
