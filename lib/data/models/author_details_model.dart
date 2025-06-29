import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'author_details_model.g.dart';

@HiveType(typeId: 7) // Unique typeId for AuthorDetailsModel
@JsonSerializable(fieldRename: FieldRename.snake)
class AuthorDetailsModel extends Equatable {
  @HiveField(0)
  final String? name;
  @HiveField(1)
  final String? username;
  @HiveField(2)
  final String? avatarPath;
  @HiveField(3)
  final double? rating;

  const AuthorDetailsModel({
    this.name,
    this.username,
    this.avatarPath,
    this.rating,
  });

  factory AuthorDetailsModel.fromJson(Map<String, dynamic> json) {
    return AuthorDetailsModel(
      name: json['name'] as String?,
      username: json['username'] as String?,
      avatarPath: json['avatar_path'] as String?,
      rating:
          json['rating'] != null
              ? double.tryParse(json['rating'].toString())
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': username,
      'avatar_path': avatarPath,
      'rating': rating,
    };
  }

  @override
  List<Object?> get props => [name, username, avatarPath, rating];
}
