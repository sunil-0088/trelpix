import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'genre_model.g.dart';

@HiveType(typeId: 1)
class GenreModel extends Equatable {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;

  const GenreModel({required this.id, required this.name});

  factory GenreModel.fromJson(Map<String, dynamic> json) {
    return GenreModel(id: json['id'] as int, name: json['name'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }

  @override
  List<Object?> get props => [id, name];
}
