import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';
import 'package:trelpix/domain/entities/cast.dart';

part 'cast_model.g.dart';

@HiveType(typeId: 3)
@JsonSerializable(fieldRename: FieldRename.snake)
class CastModel extends Cast {
  @override
  @HiveField(0)
  final int id;
  @override
  @HiveField(1)
  final String name;
  @override
  @HiveField(2)
  @JsonKey(name: 'profile_path')
  final String? profilePath;
  @override
  @HiveField(3)
  final String? character;

  const CastModel({
    required this.id,
    required this.name,
    this.profilePath,
    this.character,
  }) : super(
         id: id,
         name: name,
         profilePath: profilePath,
         character: character,
       );

  factory CastModel.fromJson(Map<String, dynamic> json) =>
      _$CastModelFromJson(json);

  Map<String, dynamic> toJson() => _$CastModelToJson(this);

  factory CastModel.fromEntity(Cast cast) {
    return CastModel(
      id: cast.id,
      name: cast.name,
      profilePath: cast.profilePath,
      character: cast.character,
    );
  }
}
