import 'package:json_annotation/json_annotation.dart';

part 'collins_search_response.g.dart';

@JsonSerializable(createToJson: false)
class CollinsSearchResponse {
  CollinsSearchResponse({required this.results});
  factory CollinsSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$CollinsSearchResponseFromJson(json);

  final List<CollinsSearchResult> results;
}

@JsonSerializable(createToJson: false)
class CollinsSearchResult {
  CollinsSearchResult({required this.entryUrl, required this.entryId});
  factory CollinsSearchResult.fromJson(Map<String, dynamic> json) =>
      _$CollinsSearchResultFromJson(json);

  final String entryUrl;
  final String entryId;
}
