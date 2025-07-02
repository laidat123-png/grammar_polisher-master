import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../configs/hive/hive_types.dart';
import 'example.dart';

part 'generated/sense.freezed.dart';

part 'generated/sense.g.dart';

@freezed
@HiveType(typeId: HiveTypes.sense)
class Sense with _$Sense {
  const factory Sense({
    @HiveField(0) @Default("") String definition,
    @HiveField(1) @Default([]) List<Example> examples,
    @HiveField(2) @Default([]) List<String> synonyms,
    @HiveField(3) @Default([]) List<String> antonyms,
    @HiveField(4) @Default("") String vi,
  }) = _Sense;

  factory Sense.fromJson(Map<String, dynamic> json) => _$SenseFromJson(json);
}
