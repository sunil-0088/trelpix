import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';
import 'package:trelpix/domain/entities/author_details.dart';

part 'author_details_model.g.dart';

@HiveType(typeId: 7) // Unique typeId for AuthorDetailsModel
@JsonSerializable(fieldRename: FieldRename.snake)
class AuthorDetailsModel extends AuthorDetails {
  @HiveField(0)
  final String? name;

  @HiveField(1)
  final String? username;

  @HiveField(2)
  final String? avatarPath;

  @HiveField(3)
  @JsonKey(fromJson: _parseRating, toJson: _toJsonRating)
  final double? rating;

  const AuthorDetailsModel({
    this.name,
    this.username,
    this.avatarPath,
    this.rating,
  }) : super(
         name: name,
         username: username,
         avatarPath: avatarPath,
         rating: rating,
       );

  factory AuthorDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$AuthorDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthorDetailsModelToJson(this);

  factory AuthorDetailsModel.fromEntity(AuthorDetails authorDetails) {
    return AuthorDetailsModel(
      name: authorDetails.name,
      username: authorDetails.username,
      avatarPath: authorDetails.avatarPath,
      rating: authorDetails.rating,
    );
  }

  // 👇 Custom parser for rating
  static double? _parseRating(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static dynamic _toJsonRating(double? value) => value;
}
