import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';
import 'package:trelpix/domain/entities/genre.dart';

part 'genre_model.g.dart';

@HiveType(typeId: 1)
@JsonSerializable(fieldRename: FieldRename.snake)
class GenreModel extends Genre {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;

  const GenreModel({required this.id, required this.name})
    : super(id: id, name: name);

  factory GenreModel.fromJson(Map<String, dynamic> json) =>
      _$GenreModelFromJson(json);

  Map<String, dynamic> toJson() => _$GenreModelToJson(this);

  factory GenreModel.fromEntity(Genre genre) {
    return GenreModel(id: genre.id, name: genre.name);
  }
}
