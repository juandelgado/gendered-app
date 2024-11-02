import 'package:json_annotation/json_annotation.dart';

part 'collins_entry_response.g.dart';

@JsonSerializable(createToJson: false)
class CollinsEntryResponse {
  CollinsEntryResponse({
    required this.entryContent,
    required this.entryLabel,
  });
  factory CollinsEntryResponse.fromJson(Map<String, dynamic> json) =>
      _$CollinsEntryResponseFromJson(json);

  final String entryContent;
  final String entryLabel;
}
