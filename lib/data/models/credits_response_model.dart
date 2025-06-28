import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';
import 'package:trelpix/data/models/cast_model.dart';

part 'credits_response_model.g.dart';

@HiveType(typeId: 4) // Unique typeId for CreditsResponseModel
@JsonSerializable(fieldRename: FieldRename.snake)
class CreditsResponseModel extends HiveObject {
  // Extend HiveObject for convenience with put/get
  @HiveField(0)
  final int id;
  @HiveField(1)
  final List<CastModel> cast;

  CreditsResponseModel({required this.id, required this.cast});

  factory CreditsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CreditsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreditsResponseModelToJson(this);
}
