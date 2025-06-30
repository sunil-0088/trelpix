import 'package:equatable/equatable.dart';
import 'package:trelpix/domain/entities/author_details.dart';

class Review extends Equatable {
  final String id;
  final String author;
  final String content;
  final String? url;
  final AuthorDetails? authorDetails;
  final DateTime? updatedAt;

  const Review({
    required this.id,
    required this.author,
    required this.content,
    this.url,
    this.authorDetails,
    this.updatedAt,
  });

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
