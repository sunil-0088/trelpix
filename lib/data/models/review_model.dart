import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:trelpix/data/models/author_details_model.dart';

part 'review_model.g.dart';

@HiveType(typeId: 5)
class ReviewModel extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String author;
  @HiveField(2)
  final String content;
  @HiveField(3)
  final String? url;
  @HiveField(4)
  final AuthorDetailsModel? authorDetails;
  @HiveField(5)
  final DateTime? updatedAt;

  const ReviewModel({
    required this.id,
    required this.author,
    required this.content,
    this.url,
    this.authorDetails,
    this.updatedAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String,
      author: json['author'] as String,
      content: json['content'] as String,
      url: json['url'] as String?,
      authorDetails:
          json['author_details'] != null
              ? AuthorDetailsModel.fromJson(
                json['author_details'] as Map<String, dynamic>,
              )
              : null,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'] as String)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author,
      'content': content,
      'url': url,
      'author_details': authorDetails?.toJson(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    author,
    content,
    url,
    authorDetails,
    updatedAt,
  ];
}
