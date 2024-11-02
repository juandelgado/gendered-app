import 'package:json_annotation/json_annotation.dart';

part 'embedded_noun.g.dart';

@JsonSerializable(createToJson: false)
class EmbeddedNoun {
  EmbeddedNoun({required this.noun});
  factory EmbeddedNoun.fromJson(Map<String, dynamic> json) =>
      _$EmbeddedNounFromJson(json);

  final String noun;
}
