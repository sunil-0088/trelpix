import 'package:equatable/equatable.dart';

class AuthorDetails extends Equatable {
  final String? name;
  final String? username;
  final String? avatarPath;
  final double? rating;

  const AuthorDetails({this.name, this.username, this.avatarPath, this.rating});

  String? get fullAvatarUrl {
    if (avatarPath == null) return null;
    // TMDB avatar paths can be absolute (starting with /https) or relative.
    if (avatarPath!.startsWith('/https')) {
      return avatarPath!.substring(1); // Remove leading slash for absolute URLs
    }
    return 'https://image.tmdb.org/t/p/w500$avatarPath';
  }

  @override
  List<Object?> get props => [name, username, avatarPath, rating];
}
