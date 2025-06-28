import 'package:equatable/equatable.dart';

class Cast extends Equatable {
  final int id;
  final String name;
  final String? profilePath;
  final String? character;

  const Cast({
    required this.id,
    required this.name,
    this.profilePath,
    this.character,
  });

  String? get fullProfileUrl =>
      profilePath != null
          ? 'https://image.tmdb.org/t/p/w500$profilePath'
          : null;

  @override
  List<Object?> get props => [id, name, profilePath, character];
}
