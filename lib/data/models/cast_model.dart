import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'cast_model.g.dart';

@HiveType(typeId: 3)
class CastModel extends Equatable {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String? profilePath;
  @HiveField(3)
  final String? character;

  const CastModel({
    required this.id,
    required this.name,
    this.profilePath,
    this.character,
  });

  factory CastModel.fromJson(Map<String, dynamic> json) {
    return CastModel(
      id: json['id'] as int,
      name: json['name'] as String,
      profilePath: json['profile_path'] as String?,
      character: json['character'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profile_path': profilePath,
      'character': character,
    };
  }

  @override
  List<Object?> get props => [id, name, profilePath, character];
}
