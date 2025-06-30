import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:trelpix/data/models/cast_model.dart';

part 'credits_response_model.g.dart';

@HiveType(typeId: 4)
class CreditsResponseModel extends Equatable {
  @HiveField(0)
  final int id; // The movie ID for which credits are fetched
  @HiveField(1)
  final List<CastModel> cast;
  // @HiveField(2)
  // final List<CrewModel> crew; // If you need crew details

  const CreditsResponseModel({
    required this.id,
    this.cast = const [],
    // this.crew = const [],
  });

  factory CreditsResponseModel.fromJson(Map<String, dynamic> json) {
    return CreditsResponseModel(
      id: json['id'] as int,
      cast:
          (json['cast'] as List<dynamic>?)
              ?.map((e) => CastModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      // crew: (json['crew'] as List<dynamic>?)
      //         ?.map((e) => CrewModel.fromJson(e as Map<String, dynamic>))
      //         .toList() ??
      //     const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cast': cast.map((e) => e.toJson()).toList(),
      // 'crew': crew.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [id, cast]; // Add crew if you include it
}
